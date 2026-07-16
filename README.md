# 2D Inverse FFT Interactive Demo

任意の画像が正弦波の重ね合わせであることを、Fourier振幅スペクトル上のドラッグ操作でインタラクティブに確認できるデモです。MATLAB版デモ（後述）のPython/Google Colab移植版です。

## 使い方

Google Colaboratoryでノートブックを開いて実行します。下表のリンクからColabが起動します。**必ずご自身のGoogle Driveにコピーを保存してから**編集してください。

**ファイル → ドライブにコピーを保存**

ノートブック内の「画像の準備」セルで、画像の読み込み元を以下から選択できます。
- Google Drive（既定）
- このリポジトリのGitHub上の画像（`IMAGE_SOURCE = 'github'`）
- ローカル環境の画像（`IMAGE_SOURCE = 'local'`）

詳しい操作方法は [`Document/IFFTDemo_Colab.md`](Document/IFFTDemo_Colab.md) を参照してください。

## ノートブック一覧

| 内容 | リンク |
|---|---|
| 2D Inverse FFT Interactive Demo | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/AquilaITOH/2DIFFT_demo/blob/main/Script/IFFTDemo_Colab.ipynb) |

## 注意事項

- 実行には matplotlib のインタラクティブバックエンド（ipympl）が必要です。初回実行時は、セルの指示に従いインストール後にランタイムを再起動してください。
- Google Drive を画像ソースにする場合は、事前にご自身のDriveへ画像をアップロードしておく必要があります。
- ノートブックの内容は今後更新される場合があります。

## ライセンス・原作について

This project is a Python port of the original MATLAB implementation:

Two-Dimensional Fourier Image Reconstruction (Inverse FT) Demo using Matlab

Original Authors:
    Kota S. Sasaki and Izumi Ohzawa
    Graduate School of Frontier Biosciences, Osaka University

Ported to Python by:
    Akira ITOH
    Department of Radiological Technology
    Faculty of Health Sciences
    Kobe Tokiwa University

The original BSD license and copyright notice have been retained.
