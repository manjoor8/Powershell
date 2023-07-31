#Base64 Encode
[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("hello"))

#Base64 Decode
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("aGVsbG8="))
