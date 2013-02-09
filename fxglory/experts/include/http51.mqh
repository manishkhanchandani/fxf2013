#import "http51.dll"

string httpGET    (string URL, int  status []);
string httpDELETE (string URL, int  status []);
string httpPUT    (string URL, string RequestBody, int  status []);
string httpPOST   (string URL, string RequestBody, int  status []);
string httpTRACE  (string URL, string RequestBody, int  status []);

string URLEncode(string toCode) {
  int max = StringLen(toCode);

  string RetStr = "";
  for(int i=0;i<max;i++) {
    string c = StringSubstr(toCode,i,1);
    int  asc = StringGetChar(c, 0);

    if((asc > 47 && asc < 58) || (asc > 64 && asc < 91) || (asc > 96 && asc < 123)) 
      RetStr = StringConcatenate(RetStr,c);
    else if (asc == 32)
      RetStr = StringConcatenate(RetStr,"+");
    else {
      RetStr = StringConcatenate(RetStr,"%",hex(asc));
    }
  }
  return (RetStr);
}

string ArrayEncode(string &array[][]) {
   string ret = "";
   string key,val;
   int l = ArrayRange(array,0);
   for (int i=0;i<l;i++) {
      key = URLEncode(array[i,0]);
      val = URLEncode(array[i,1]);
      ret = StringConcatenate(ret,key,"=",val);
      if (i+1<l) ret = StringConcatenate(ret,"&");
   }
   return (ret);
}

void addParam(string key, string val, string&array[][]) {
   int l = ArrayRange(array,0);
   if (ArrayResize(array, l+1)>-1) {
      array[l][0]=key;
      array[l][1]=val;
   }
}

string hex(int i) {
   static string h =  "0123456789ABCDEF";
   string ret="";
   int a = i % 16;
   int b = (i-a)/16;
   if (b>15) ret = StringConcatenate(hex(b), StringSubstr(h,a,1));
   else      ret = StringConcatenate(StringSubstr(h, b ,1), StringSubstr(h,a,1));
   
   return (ret);
}

