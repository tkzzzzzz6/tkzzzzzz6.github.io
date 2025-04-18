// 几点几分了？

// 测试输入：23456 预期输出： 6 : 30 : 56

// 测试输入： 34567 预期输出： 9 : 36 : 7

#include <iostream>
using namespace std;

void whatTime(int secs, int &h, int &m, int &s)
{
    /********** Begin *********/
    h = secs / 3600;
    m = (secs % 3600) / 60;
    s = secs % 60;
    /********** End **********/
}

int main()
{
    int secs;
    int h, m, s;
    cin >> secs;
    whatTime(secs, h, m, s);
    cout << h << ":" << m << ":" << s << endl;
    return 0;
}