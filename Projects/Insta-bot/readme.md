## Getting AccessToken

1. Visit: https://developers.facebook.com/apps/ 
  or https://developers.facebook.com/apps/1056299262668332/instagram-business/API-Setup/

2. Open option for instagram at left side

3. Click Generate Access Token

4. Add account until asked for permissions.

5. generate and copy Access Token

## Downloading video
### Usage

```
./youtube_downloader.sh <YouTube-URL> [cookies-file] [output-name]
```
1. Basic download:
```
./youtube_downloader.sh 'https://youtu.be/example'
```

2. With cookies file:
```
./youtube_downloader.sh 'https://youtu.be/example' cookies.txt
```

3. Custom output name:
```
./youtube_downloader.sh 'https://youtu.be/example' cookies.txt myVideo
```