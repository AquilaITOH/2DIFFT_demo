# 2D Inverse FFT Interactive Demo（Python / Google Colab 版）

任意の画像が正弦波の重ね合わせであることを、Fourier 振幅スペクトル上のドラッグ操作でインタラクティブに確かめるデモです。

## 原作について

本スクリプトは以下 MATLAB 版デモの Python 移植です。オリジナルの設計・アルゴリズムはすべて原作者に基づきます。

> **Two-Dimensional Fourier Image Reconstruction (Inverse FT) Demo using Matlab**
> Authors: Kota S. Sasaki and Izumi Ohzawa
> Graduate School of Frontier Biosciences, Osaka University
> License: BSD license
> （原文: [`MATLAB/InverseFFT2D/00_README.txt`](../MATLAB/InverseFFT2D/00_README.txt)）

- 2026-07-16: Akira ITOH（神戸常盤大学 保健科学部 診療放射線技術学科）が Python へ移植し、Google Colab 上での実行に対応。

移植にあたり、`IFFTDemo.m` / `GetLuminanceImage.m` / `Myff2.m` の3ファイルの機能を `Script/IFFTDemo_Colab.ipynb` 1本のノートブックにまとめています。

## 前提環境

- Google Colab（推奨）。ローカル Jupyter でも動作しますが、その場合はノートブック内の切り替え設定が必要です。
- 画像ソースは Google Drive を既定とします（`IMAGE_SOURCE = 'gdrive'`）。

## 使い方

1. **ステップ1・ステップ2のセル**を順に実行し、`ipympl`（インタラクティブ描画用）を有効化する
   - Colab では初回実行時に「ランタイムの再起動」が必要な場合があります。指示に従って再起動後、ステップ1のセルを再実行してください。
2. **画像の準備セル**で以下を設定して実行する
   - `GDRIVE_IMAGE_DIR`（`GDRIVE_SUBDIR`）を自分の Google Drive 内のフォルダ名に変更する
   - ローカル Jupyter で実行する場合は `IMAGE_SOURCE = 'local'` に変更する
3. Google Drive のマウント許可ダイアログが出たら「許可」を選ぶ
4. 残りのセルを順に実行する

画像が見つからない場合は、エラーメッセージとともに Drive 内のフォルダ・画像候補が一覧表示されます。`list_drive()` セルを使えば Drive 内の構造を確認できます。

## 操作方法

- 振幅スペクトル（上中・下中パネル）上でマウスをドラッグする
- 通過した周波数成分が逐次 IFFT に加算され、**下左パネル**に再合成画像が現れる
- **下右パネル**に最後に追加したグレーティング（正弦波成分、コントラストは表示用に正規化）が表示される
- **Reset** ボタンでマスクと表示をリセット

## 画面構成

| 位置 | 内容 |
|---|---|
| 上左 | 元画像（グレースケール輝度） |
| 上中 | 振幅スペクトル（対数スケール） |
| 下左 | 選択済み周波数成分から再合成した画像 |
| 下中 | 周波数成分の「ピッカー」（選択済み成分の表示） |
| 下右 | 直近に追加したグレーティング（正弦波成分） |

## MATLAB版との対応

| MATLAB | Python（`IFFTDemo_Colab.ipynb` 内） |
|---|---|
| `GetLuminanceImage.m` | `get_luminance_image()` |
| `Myff2.m` | `myff2()` |
| `IFFTDemo.m`（マスク更新・線分補間） | `draw_line_on_mask()` |
| `IFFTDemo.m`（GUI・イベント処理・描画） | `IFFTDemo` クラス |

## 既知の制約

- Colab の Notebook UI 上でのマウスドラッグ操作は `%matplotlib widget`（ipympl）を介するため、ブラウザやネットワーク環境によって描画がやや遅延することがあります。
- `IMAGE_SOURCE = 'gdrive'` は Colab 専用です。ローカル実行では `'local'` を指定してください。

## ライセンス

原作 MATLAB 版の BSD ライセンスを継承します。
