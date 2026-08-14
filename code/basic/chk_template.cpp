#include <bits/stdc++.h>
#include <stdlib.h>
using namespace std;
int main(){
  string wa,ac,ge,file;
  puts("[!]输入文件不要输入拓展名");
  printf("[>]Input FILES: ");
  cin>>file;
  printf("[>]Input wrong code filename: ");
  cin>>wa;
  wa="g++ -g3 -std=c++20 "+wa+".cpp -o "+file+"/WA";
  printf("[>]Input brutforce code filename: ");
  cin>>ac;
  ac="g++ -g3 -std=c++20 "+ac+".cpp -o "+file+"/AC";
  printf("[>]Input data generator filename: ");
  cin>>ge;
  ge="g++ -g3 -std=c++20 "+ge+".cpp -o "+file+"/GEN";
  string tmp="mkdir "+file;
  system(tmp.c_str());
  puts("[+]compiling wa...");
  if(system(wa.c_str())){
    puts("[+]Fail to compile wa");
    return 0;
  }else{
    puts("[+]Compile pass");
  }
  puts("[+]compiling ac...");
  if(system(ac.c_str())){
    puts("[+]Fail to compile ac");
    return 0;
  }else{
    puts("[+]Compile pass");
  }
  puts("[+]compiling gen...");
  if(system(ge.c_str())){
    puts("[+]Fail to compile gen");
    return 0;
  }else{
    puts("[+]Compile pass");
  }
  tmp="cd "+file;
  // system(tmp.c_str());
  int trytimes=0;
  while(1){
    printf("[+]The %d-th round\n",++trytimes);
    system(("./"+file+"/GEN > "+file\
      +"/data.in").c_str());
    system(("./"+file+"/AC < "+file+\
      "/data.in > "+file+"/ac.out").c_str());
    system(("./"+file+"/WA < "+file+\
      "/data.in > "+file+"/wa.out").c_str());
    if(system(("diff -b -B -q -Z "+\
      file+"/ac.out "+file+"/wa.out").c_str())){
      puts("[+]diff Find!");
      break;
    }else puts("[+]testcase Pass");
  }
  // system("rm "+file+"/GEN AC WA");
  return 0;
}