# 作品
## サイトURL
https://grocerymap-for-portfolio-2bef59300c70.herokuapp.com/

# アプリについて
食料品の価格情報を投稿、閲覧することができます。  
既存の特売情報には掲載されていない情報を投稿、閲覧し日々の買い物に役立てることが出来ます。

# 技術
## 使用技術
### フロントエンド
+ Bootstrap: フロントエンドフレームワーク
### バックエンド
+ Ruby on Rails: Webアプリケーションフレームワーク  
+ PostgreSQL: データベース管理システム  
+ RSpec: テストフレームワーク  
+ Google Maps API: 地図および位置情報サービス  
### インフラ
+ Heroku: アプリケーションホスティングプラットフォーム  
+ GitHub: ソースコード管理およびバージョン管理サービス  

## ER図
<img width="1049" alt="スクリーンショット 2024-08-20 18 14 38" src="https://github.com/user-attachments/assets/0ade7495-7013-4cbb-a92b-0e0aa3d5ef68">

# 機能紹介
## トップページ
トップページから食料品店の検索、価格情報の検索をすることが出来ます。
<img width="1424" alt="スクリーンショット 2024-08-20 18 18 53" src="https://github.com/user-attachments/assets/3e32e726-2d5c-4a59-a555-fa82cbaa8378">
<img width="1425" alt="スクリーンショット 2024-08-20 18 19 14" src="https://github.com/user-attachments/assets/deaec04d-f6ad-4f96-9289-de6a7cf51573">

## サインインページ
新規登録、サインイン、ログアウトが出来ます。
<img width="1440" alt="スクリーンショット 2024-08-20 18 18 04" src="https://github.com/user-attachments/assets/b534e7df-f3c3-46be-a648-c19f769a2471">

## プロフィール機能
プロフィール情報の閲覧、編集ができます。
<img width="1440" alt="スクリーンショット 2024-08-20 17 58 43" src="https://github.com/user-attachments/assets/97366312-352b-4432-a9a7-f536f2dd8b39">

## 食料品店検索ページ
トップページから食料品店を検索し店舗詳細ページにアクセスすると、店舗に投稿された価格情報の一覧と店舗の情報が閲覧出来ます。
また、価格情報の投稿、商品の追加登録も本ページからアクセス可能です。
<img width="1424" alt="スクリーンショット 2024-08-20 18 19 38" src="https://github.com/user-attachments/assets/111742a8-6bb8-4955-88f3-1a910ee4abf0">

## 食料品店のお気に入り登録機能
店舗名の横に並ぶハートマークをクリックすることで、店舗をお気に入り登録することが可能です。
<img width="1422" alt="スクリーンショット 2024-08-20 18 02 46" src="https://github.com/user-attachments/assets/eda6d19a-1801-43b3-82cb-2eb989981856">

##　 価格情報の閲覧、投稿機能
投稿された価格情報の備考など詳細を確認、及び価格情報の登録が出来ます。
<img width="1440" alt="スクリーンショット 2024-08-20 18 03 45" src="https://github.com/user-attachments/assets/38acae4e-cd0a-4b1c-a16f-9f2b54e78499">
<img width="1440" alt="スクリーンショット 2024-08-20 18 04 10" src="https://github.com/user-attachments/assets/394cc94e-1ea8-4ad1-9755-7e0f285baded">

## 食料品の登録機能
価格情報を投稿したい商品が登録されていない場合、本ページから投稿することが出来ます。
<img width="1440" alt="スクリーンショット 2024-08-20 18 05 14" src="https://github.com/user-attachments/assets/308011aa-9127-426c-ae0d-dfc4abd8bcb3">

## 価格情報の検索機能
ヘッダーの検索ウィンドウから価格情報を商品名や備考からあいまい検索することが出来ます。
<img width="1440" alt="スクリーンショット 2024-08-20 18 21 08" src="https://github.com/user-attachments/assets/2ec5068e-f755-42e9-9b93-36ac4570ac98">

## お気に入り店舗内での食料品検索機能
お気に入りに登録した店舗に登録されている価格情報のみを検索することが出来ます。
<img width="1440" alt="スクリーンショット 2024-08-20 18 21 36" src="https://github.com/user-attachments/assets/728cc0c1-a6ef-4abf-b830-d9f8797180b1">
<img width="1440" alt="スクリーンショット 2024-08-20 18 21 44" src="https://github.com/user-attachments/assets/85aa1f38-ddc8-46cd-883f-8e039738dbdb">

# 機能一覧
サインイン機能：サインアップ・サイインイン・ログアウト  
プロフィール機能：プロフィール情報を編集できます。  
食料品店の検索機能：Google Maps APIを用いた食料品店の検索が可能です。  
食料品店のお気に入り登録機能：検索した店舗をお気に入り登録することが出来ます。  
価格情報の閲覧、投稿機能：価格情報を投稿することが出来ます。  
食料品の登録機能：食料品を登録することが出来ます。  
価格情報の検索機能：食料品名や価格情報に投稿された備考欄から価格情報を検索することが出来ます。  
お気に入り店舗内での食料品検索機能：お気に入りした店舗にて投稿された価格情報を検索することが出来ます。  

# 今後の課題
価格情報が不足している場合に検索、比較が十分に出来ないことが機能面における一番の課題だと考え、
別途APIを導入する等の方法を検討しています。
また、実際に利用したユーザーより商品の分類をより細かくしてほしいという意見をいただいたため、
商品データの重複が無いように管理しやすく、且つ詳細な商品データを提供する方法についても検討中となります。
