//
// Dumb HTTP Client library for Metatrader 4 / MT4 / MQL4 - 0.1
//
//    Native scripting, no external dll required but standard windows wininet
//    with (ascii/binary) file uploads as well -  by gunzip <spammmmme@gmail.com>
//
// USAGE EXAMPLE
//
//    #include <ghttp.mqh>
//
//    string params[2][2];
//    params[0][0] = "key1";
//    params[0][1] = "value1";
//    params[1][0] = "key2";
//    params[1][1] = "value2";
//
//    string filenames[1][2];
//    filenames[0][0] = "uploaded";
//    filenames[0][1] = "test.txt"; 
//
//    string response;
//  
//    HttpPOST("127.0.0.1", "/upload.php", params, filenames, response);
//    HttpGET("http://www.google.com?q=hello", response);
//    Comment(response);
//
//    * note that you _must_ pass two arrays for params and filenames. 
//      pass an empty two dimensional array if you have no files/params (ie. string params[][];)
//
// GREETS GO TO
//
//    - http://www.desynced.net/fx/eas/mq4script-12241.php - grabweb library for mt4
//    - http://codebase.mql4.com/4428 - mt4 http client by JavaDev
//    - http://stackoverflow.com/questions/1985345/dev-c-wininet-upload-file-using-http
//    - http://stackoverflow.com/questions/471198/is-there-any-good-example-of-http-upload-using-wininet-c-library
//    - http://source.winehq.org/source/include/wininet.h

#include <stdlib.mqh>

#import "wininet.dll"

#define INTERNET_OPEN_TYPE_DIRECT       0
#define INTERNET_OPEN_TYPE_PRECONFIG    1
#define INTERNET_OPEN_TYPE_PROXY        3

// Had to cut the following two defines because of silly MQL4 identifier limits

#define _IGNORE_REDIRECT_TO_HTTP        0x00008000
#define _IGNORE_REDIRECT_TO_HTTPS       0x00004000

#define INTERNET_FLAG_KEEP_CONNECTION   0x00400000
#define INTERNET_FLAG_NO_AUTO_REDIRECT  0x00200000
#define INTERNET_FLAG_NO_COOKIES        0x00080000
#define INTERNET_FLAG_RELOAD            0x80000000
#define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000
#define INTERNET_FLAG_DONT_CACHE        0x04000000
#define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100
#define INTERNET_FLAG_NO_UI             0x00000200

#define HTTP_ADDREQ_FLAG_ADD            0x20000000
#define HTTP_ADDREQ_FLAG_REPLACE        0x80000000

#define INTERNET_SERVICE_HTTP           3
#define INTERNET_DEFAULT_HTTP_PORT      80

#define ICU_ESCAPE                      0x80000000
#define ICU_USERNAME                    0x40000000
#define ICU_NO_ENCODE                   0x20000000
#define ICU_DECODE                      0x10000000
#define ICU_NO_META                     0x08000000
#define ICU_ENCODE_PERCENT              0x00001000
#define ICU_ENCODE_SPACES_ONLY          0x04000000
#define ICU_BROWSER_MODE                0x02000000

#define AGENT                           "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)"
#define BUFSIZ                          128

#define REQUEST_FILE                    "_req.txt"

////////////// PROTOTYPES

bool InternetCanonicalizeUrlA(string lpszUrl, string lpszBuffer, int& lpdwBufferLength[], int dwFlags);

int InternetOpenA(string sAgent, int lAccessType, string sProxyName="", string sProxyBypass="", int lFlags=0);

int InternetOpenUrlA(int hInternetSession, string sUrl, string sHeaders="", int lHeadersLength=0, int lFlags=0,
   int lContext=0);

int InternetReadFile(int hFile, string sBuffer, int lNumBytesToRead, int& lNumberOfBytesRead[]);

int InternetCloseHandle(int hInet);

int InternetConnectA(int handle, string host, int port, string user, string pass, int service, int flags, int context);

bool HttpSendRequestA(int handle, string headers, int headersLen, int& optional[], int optionalLen);

bool HttpAddRequestHeadersA(int handle, string headers, int headersLen, int modifiers);

int HttpOpenRequestA(int hConnect, string lpszVerb, string lpszObjectName, string lpszVersion,
 string lpszReferer, string& lplpszAcceptTypes[], int dwFlags, int dwContext);

#import

//////// CODE

bool HttpGET(string strUrl, string& strWebPage)
{
  int hSession = InternetOpenA(AGENT, INTERNET_OPEN_TYPE_DIRECT, "0", "0", 0);

  int hReq = InternetOpenUrlA(hSession, strUrl, "0", 0,
        INTERNET_FLAG_NO_CACHE_WRITE |
        INTERNET_FLAG_PRAGMA_NOCACHE |
        INTERNET_FLAG_RELOAD, 0);

  if (hReq == 0) {
    return(false);
  }

  int     lReturn[]  = {1};
  string  sBuffer    = "";

  while (TRUE) {
    if (InternetReadFile(hReq, sBuffer, BUFSIZ, lReturn) <= 0 || lReturn[0] == 0) {
      break;
    }
    strWebPage = StringConcatenate(strWebPage, StringSubstr(sBuffer, 0, lReturn[0]));
  }

  InternetCloseHandle(hReq);
  InternetCloseHandle(hSession);

  return (true);
}

/////////// POST

bool HttpPOST(string host, string script, string params[][], string filenames[][], string& strWebPage)
{
  int hIntrn = InternetOpenA(AGENT, INTERNET_OPEN_TYPE_DIRECT, "0", "0", 0);
  if (hIntrn == 0) {
    return (false);
  }

  int hConn = InternetConnectA(hIntrn,
                              host,
                              INTERNET_DEFAULT_HTTP_PORT,
                              NULL,
                              NULL,
                              INTERNET_SERVICE_HTTP,
                              0,
                              NULL);

  if (hConn == 0) {
    return (false);
  }

  int dwOpenRequestFlags =   // _IGNORE_REDIRECT_TO_HTTP |
                             // _IGNORE_REDIRECT_TO_HTTPS |
                             // INTERNET_FLAG_KEEP_CONNECTION |
                             // INTERNET_FLAG_NO_AUTO_REDIRECT |
                             // INTERNET_FLAG_NO_COOKIES |
                             // INTERNET_FLAG_NO_CACHE_WRITE |
                             INTERNET_FLAG_NO_UI |
                             INTERNET_FLAG_RELOAD;

  string accept[] = {"Accept: text/*\r\n"};

  int hReq = HttpOpenRequestA(hConn,
                             "POST",
                             script,
                             "HTTP/1.0",
                             NULL,
                             accept,
                             dwOpenRequestFlags,
                             NULL);

  string strBoundary = "---------------------------HOFSTADTER";
  string strContentHeader = "Content-Type: multipart/form-data; boundary=" + strBoundary;

  HttpAddRequestHeadersA(hReq, strContentHeader, StringLen(strContentHeader), HTTP_ADDREQ_FLAG_REPLACE);

  int i     = 0,
      idx   = 0,
      r     = 0,
      len   = 0
  ;

  string hdr = "";

  int _req = FileOpen(REQUEST_FILE, FILE_BIN|FILE_WRITE);
  if(_req <= 0) {
    return (false);
  }

  // Add parameters to request body

  for (i = ArrayRange(params, 0) - 1; i >= 0; i--) {
    hdr = StringConcatenate(
      "--", strBoundary, "\r\n",
      "Content-Disposition: form-data; name=\"", params[i][0], "\"\r\n\r\n",
      params[i][1], "\r\n");
    FileWriteString(_req, hdr, StringLen(hdr));
  }

  // Add files to request body
  
  for (i = ArrayRange(filenames, 0) - 1; i >= 0; i--) {
    hdr = StringConcatenate(
      "--", strBoundary, "\r\n",
      "Content-Disposition: form-data; name=\"", filenames[i][0], "\"; filename=\"", filenames[i][1], "\"\r\n",
      "Content-Type: application/octet-stream\r\n\r\n");

    FileWriteString(_req, hdr, StringLen(hdr));

    int handle = FileOpen(filenames[i][1], FILE_BIN|FILE_READ);
    if(handle <= 0) {
      return (false);
    }
    len = FileSize(handle);
    for (int b = 0; b < len; b++) {
      FileWriteInteger(_req, FileReadInteger(handle, CHAR_VALUE), CHAR_VALUE);
    }
    FileClose(handle);
  }

  string boundaryEnd = "\r\n--" + strBoundary + "--\r\n";
  FileWriteString(_req, boundaryEnd, StringLen(boundaryEnd));

  FileClose(_req);

  // Re-reads saved POST data byte-to-byte from file in the pseudo-character array
  //  we need to send with HttpSendRequestA. This is due to the fact I know no clean
  //  way to cast strings _plus_ binary file contents to a character array in MQL.
  //  If you know how to do it properly feel free to contact me.

  int request[];

  _req = FileOpen(REQUEST_FILE, FILE_BIN|FILE_READ);
  if (_req <= 0) {
    return (false);
  }
  len = FileSize(_req);

  ArrayResize(request, len);
  ArrayInitialize(request, 0);

  for (i = 0; i < len; i++) {
    request[r] |= FileReadInteger(_req, CHAR_VALUE) << (idx * 8);
    idx = (idx + 1) %4;
    if (idx == 0) {
      r++;
    }
  }
  FileClose(_req);

  if (!HttpSendRequestA(hReq, NULL, 0, request, len)) {
    return (false);
  }

  // Read response

  int     lReturn[]  = {1};
  string  sBuffer    = "";

  while (TRUE) {
    if (InternetReadFile(hReq, sBuffer, BUFSIZ, lReturn) <= 0 || lReturn[0] == 0) {
      break;
    }
    strWebPage = StringConcatenate(strWebPage, StringSubstr(sBuffer, 0, lReturn[0]));
  }

  InternetCloseHandle(hReq);
  InternetCloseHandle(hConn);
  InternetCloseHandle(hIntrn);

  return (true);
}

string UrlEncode(string url)
{
  string out = "";
  int len    = StringLen(url);
  
  for (int i = 0; i < len; i++) {
    int c = StringGetChar(url, i);
    if (_IsReservedChar(c)) {
      out = StringConcatenate(out, "%", StringSubstr(IntegerToHexString(c), 6, 2));
    }
    else {
      out = StringConcatenate(out, StringSubstr(url, i, 1)); 
    }
  }
  return (out);
}

bool _IsReservedChar(int c) 
{
  static int encode[] = { '!', '*', 0x27 /* single quote */, '(', ')', ';', ':', '@', 
                          '&', '=', '+', '$', '/', '?', '#', '[', ']' };
  for (int i = ArraySize(encode) - 1; i >= 0; i--) {
    if (c == encode[i]) {
      return (true);
    }
  }
  return (false);
}

