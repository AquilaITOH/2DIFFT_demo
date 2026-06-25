function IFFTDemo(filename)

if ~exist('filename', 'var') % if filename was not provided
%    filename = 'images/Albert_Einstein_Nobel_s.png'; % Einstein
%    filename = 'images/lena_std128x128.png'; % Lena
    filename = 'images/TaiyounoTou128x128t.png'; % default TaiyounoTou
end

show_log_amp = true; % flag to show log SF spectrum instead of SF spectrum
min_amp_to_show = 10 ^ -10; % small positive value to replace 0 for log SF spectrum

L = GetLuminanceImage(filename);

% calculate the number of points for FFT (power of 2)
FFT_pts = 2 .^ ceil(log2(size(L)));

[FFTedL fx fy mfx mfy] = Myff2(L, FFT_pts(1), FFT_pts(2));

mask = repmat(0, size(FFTedL)); % mask for spectrum


figure(1);
clf reset;

% callback functions for figure
set(gcf, 'WindowButtonMotionFcn', @myWindowButtonMotionFcn);
set(gcf, 'WindowButtonUpFcn', @myWindowButtonUpFcn);

uicontrol('Style', 'pushbutton', 'String', 'reset', ...
    'Units', 'normalized', 'Position', [.75 .8 .15 .05], ...
    'Callback', 's = get(gcf, ''UserData''); IFFTDemo(s.filename);');

colormap gray;

% luminance image
subplot(2, 3, 1);
imagesc(L);
% colorbar;
axis square;
set(gca, 'TickDir', 'out');
title('original image');
xlabel('x');
ylabel('y');

amp = abs(FFTedL);
if show_log_amp
    amp(find(amp < min_amp_to_show)) = min_amp_to_show; % avoid taking log 0 
    amp = log10(amp);
end

% spectral amplitude
subplot(2, 3, 2);
hAmpImage = imagesc(fx, fy, amp);
axis xy;
axis square;
set(gca, 'TickDir', 'out');
title('amplitude spectrum');
xlabel('fx (cyc/pix)');
ylabel('fy (cyc/pix)');

% callback function for axes which have amplitude spectrum image
set(hAmpImage, 'ButtonDownFcn', @myButtonDownFcn);


s.hAmpImage = hAmpImage;
s.hCurrentImage = NaN;
s.filename = filename;
s.L = L;
s.mask = mask;
s.FFTedL = FFTedL;
s.amp = amp;
s.fx = fx;
s.fy = fy;
s.mouseDragging = false;
s.oldxiyi = [NaN NaN];
s.hUnmaskedImage = []; % unmasked amplitude spectrum image handle
s.hUnmaskedAxes = []; % unmasked amplitude spectrum axes handle

set(gcf, 'UserData', s);

UpdateIFFT(s);


function myButtonDownFcn(src, eventdata)

[h hFigure] = gcbo;
s = get(hFigure, 'UserData');
s.hCurrentImage = h;
s.mouseDragging = true;
set(hFigure, 'UserData', s);

s = UpdateMask(s);
s = UpdateIFFT(s);
set(hFigure, 'UserData', s);


function myWindowButtonMotionFcn(src, eventdata)

[h hFigure] = gcbo;
s = get(hFigure, 'UserData');
if s.mouseDragging
    s = UpdateMask(s);
    s = UpdateIFFT(s);
    set(hFigure, 'UserData', s);
end


function myWindowButtonUpFcn(src, eventdata)

[h hFigure] = gcbo;
s = get(hFigure, 'UserData');
s.hCurrentImage = NaN;
s.mouseDragging = false;
s.oldxiyi = [NaN NaN];
set(hFigure, 'UserData', s);


function s = UpdateMask(s)

pt = get(get(s.hCurrentImage, 'Parent'), 'CurrentPoint');
xy = pt(1, [1 2]);

% if the point is out of the axes, invalidate mouse dragging.
if xy(1) < s.fx(1) | xy(1) > s.fx(end) | xy(2) > s.fy(1) | xy(2) < s.fy(end)
    s.hCurrentImage = NaN;
    s.mouseDragging = false;
    s.oldxiyi = [NaN NaN];
    return;
end

[minc xi] = min(abs(s.fx - xy(1)));
[minc yi] = min(abs(s.fy - xy(2)));

if isnan(s.oldxiyi(1))
    xxi = xi;
    yyi = yi;
% connect old and current points
elseif xi == s.oldxiyi(1)
    yyi = min([yi s.oldxiyi(2)]): max([yi s.oldxiyi(2)]);
    xxi = xi * repmat(1, size(yyi));
else
    slope = (yi - s.oldxiyi(2)) / (xi - s.oldxiyi(1));
    if slope < 1
        xxi = min([xi s.oldxiyi(1)]): max([xi s.oldxiyi(1)]);
        yyi = round(slope * (xxi - xi) + yi);
    else
        yyi = min([yi s.oldxiyi(2)]): max([yi s.oldxiyi(2)]);
        xxi = round(1 / slope * (yyi - yi) + xi);
    end
end

for ii = 1: length(xxi)
    s.mask(yyi(ii), xxi(ii)) = 1;
end

s.oldxiyi = [xi yi];


function s = UpdateIFFT(s)

A = real(ifft2(ifftshift(s.mask .* s.FFTedL)));
A = A(1: size(s.L, 1), 1: size(s.L, 2));

% IFFTed luminance image
subplot(2, 3, 4);
imagesc(A);
% colorbar;
axis square;
set(gca, 'TickDir', 'out');
title('IFFTed image');
xlabel('x');
ylabel('y');

% unmasked spectral amplitude
subplot(2, 3, 5);
if isempty(s.hUnmaskedImage) % 初回のみimagescを使用
    h = imagesc(s.fx, s.fy, s.mask .* s.amp);
    axis xy;
    axis square;
    set(gca, 'TickDir', 'out');
    title('unmasked amplitude spectrum');
    xlabel('fx (cyc/pix)');
    ylabel('fy (cyc/pix)');
    
    % 座標の中心を強調するために軸の設定を調整
    % 原点（0,0）を含む適切な目盛りを設定
    fx_range = s.fx(end) - s.fx(1);
    fy_range = s.fy(1) - s.fy(end);
    
    % 5つの目盛りを設定（原点を中心に）
    x_ticks = linspace(s.fx(1), s.fx(end), 5);
    y_ticks = linspace(s.fy(end), s.fy(1), 5);
    
    % 原点に最も近い目盛りを0に設定
    [~, x_center_idx] = min(abs(x_ticks));
    [~, y_center_idx] = min(abs(y_ticks));
    x_ticks(x_center_idx) = 0;
    y_ticks(y_center_idx) = 0;
    
    set(gca, 'XTick', x_ticks, 'YTick', y_ticks);
    set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.2f', x), x_ticks, 'UniformOutput', false));
    set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.2f', y), y_ticks, 'UniformOutput', false));
    
    % 原点のラベルを赤色で強調
    ax = gca;
    ax.XAxis.FontSize = 10;
    ax.YAxis.FontSize = 10;
    
    % callback function for a newly created unmasked spectral amplitude image
    set(h, 'ButtonDownFcn', @myButtonDownFcn);
    s.hUnmaskedImage = h; % ハンドルを保存
    s.hUnmaskedAxes = gca; % 軸ハンドルも保存
else % 2回目以降は画像データのみ更新
    set(s.hUnmaskedImage, 'CData', s.mask .* s.amp);
    h = s.hUnmaskedImage;
end

% the handle of the image must be remembered if necessary
% if ~isnan(s.hCurrentImage) & s.hCurrentImage ~= s.hAmpImage
if s.hCurrentImage ~= s.hAmpImage
    s.hCurrentImage = h;
end


A = repmat(0, size(s.mask));
if ~isnan(s.oldxiyi(1))
    A(s.oldxiyi(2), s.oldxiyi(1)) = 1;
    A = real(ifft2(ifftshift(A .* s.FFTedL)));
    A = A(1: size(s.L, 1), 1: size(s.L, 2));
end

% most recent grating added
subplot(2, 3, 6);
imagesc(A);
% colorbar;
axis square;
set(gca, 'TickDir', 'out');
title('most recent grating added');
xlabel('x');
ylabel('y');