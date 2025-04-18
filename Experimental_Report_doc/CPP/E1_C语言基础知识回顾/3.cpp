// 这天星期几 ?

// 测试输入：2016 1 预期输出： 2016年1月1日是星期5

// 测试输入： 2017 7 预期输出： 2017年7月1日是星期6

#include <iostream>
using namespace std;

int leapYear(int y)
{
    if (y % 4 == 0 && y % 100 != 0 || y % 400 == 0)
        return 1;
    return 0;
}

int whatDay(int year, int month)
{
    /********** Begin *********/
    // 计算从2000年1月1日到目标日期的总天数
    int days = 0;

    // 计算整年的天数
    for (int y = 2000; y < year; y++)
    {
        days += leapYear(y) ? 366 : 365;
    }

    // 计算当年月份的天数
    for (int m = 1; m < month; m++)
    {
        if (m == 2)
            days += leapYear(year) ? 29 : 28;
        else if (m == 4 || m == 6 || m == 9 || m == 11)
            days += 30;
        else
            days += 31;
    }

    // 2000年1月1日是星期六(6)
    return (days + 6) % 7;
    /********** End **********/
}

int main()
{
    int y, m, xq;
    cin >> y >> m;

    xq = whatDay(y, m);

    cout << y << "年" << m << "月1日是星期";
    if (xq == 7)
        cout << "日" << endl;
    else
        cout << xq << endl;
    return 0;
}