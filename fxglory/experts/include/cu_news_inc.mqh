//+------------------------------------------------------------------+
//|                                                  cu_news_inc.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//Currency {currency[number] 0 - year, 1, month, 2 - day, 3 - hour, 4 - min, 5 - buy currency, 6 sell currency
//gbp_str[number] 
int currency_int[50][50];
string currency_str[50][50];
int currency_limit;
void initialize()
{
   int i;
   i = 0;
   currency_int[i][0] = 2012;
   currency_int[i][1] = 8;
   currency_int[i][2] = 14;
   currency_int[i][3] = 9;
   currency_int[i][4] = 30;
   currency_int[i][5] = 1;
   currency_str[i][0] = "GBP";
   
   i = 1;
   currency_int[i][0] = 2012;
   currency_int[i][1] = 8;
   currency_int[i][2] = 14;
   currency_int[i][3] = 13;
   currency_int[i][4] = 30;
   currency_int[i][5] = 1;
   currency_str[i][0] = "USD";
   
   i = 2;
   currency_int[i][0] = 2012;
   currency_int[i][1] = 8;
   currency_int[i][2] = 22;
   currency_int[i][3] = 13;
   currency_int[i][4] = 30;
   currency_int[i][5] = 0;
   currency_str[i][0] = "CAD";
   currency_limit = i + 1;
}

void putstar(int num, string name, double price)
{
   ObjectCreate(name, OBJ_ARROW, 0, Time[num], price);
   ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
}