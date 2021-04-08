int getNoOfDays(int i,int j)
{
  if(i==1||i==3||i==5||i==7||i==8||i==10||i==12)return 31;
  else if(i==2)return isLeapYear(j)?29:28;
  else return 30;
}

int getDuration(int i,int j,int k)
{
  int duration=0;
  for(int a=1;a<=k;a++)
    {
      int noOfDays=getNoOfDays(i,j);
      duration=duration+noOfDays;
      i++;
      if(i==1)j++;
    }
  return duration;
}
bool isLeapYear(int year){
  if(year%4==0)
  {
    if(year%100==0)
    {
      if(year%400==0)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    else
    {
      return true;
    }
  }
  else
  {
    return false;
  }
}