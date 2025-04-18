// 打印日历

// 测试输入：
// 2017 6

#include <stdio.h>
#include <iostream>
    using namespace std;

void printMonth(int year, int month);

int leapYear(int y)
{
    if (y % 4 == 0 && y % 100 != 0 || y % 400 == 0)
        return 1;
    return 0;
}

int whatDay(int year, int month)
{
    int w = 1;
    int i;

    for (i = 1; i < year; i++)
    {
        if (leapYear(i))
            w += 366;
        else
            w += 365;
    }
    switch (month)
    {
    case 12:
        w += 30;
    case 11:
        w += 31;
    case 10:
        w += 30;
    case 9:
        w += 31;
    case 8:
        w += 31;
    case 7:
        w += 30;
    case 6:
        w += 31;
    case 5:
        w += 30;
    case 4:
        w += 31;
    case 3:
        if (leapYear(year))
            w += 29;
        else
            w += 28;
    case 2:
        w += 31;
    case 1:;
    }

    w = w % 7;

    if (w == 0)
        w = 7;
    return w;
}

/*************** Begin **************/
int getDaysInMonth(int year, int month) {
    if (month == 2) {
        return leapYear(year) ? 29 : 28;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        return 30;
    } else {
        return 31;
    }
}

void printMonth(int year, int month) {
    // 打印表头并保持适当的间距
    cout << "  一  二  三  四  五  六  日" << endl;
    int w = whatDay(year, month);
    int days = getDaysInMonth(year, month);
    
    // 在第一天之前打印空格
    for (int i = 0; i < w - 1; i++) {
        cout << "    ";
    }
    
    // 打印日期并保持对齐
    for (int i = 1; i <= days; i++) {
        if (i < 10) {
            cout << "   " << i;  // 个位数使用三个空格
        } else {
            cout << "  " << i;   // 两位数使用两个空格
        }
        
        // 检查是否需要换行
        if ((w - 1 + i) % 7 == 0) {
            cout << endl;
        }
    }
    cout << endl;
}
/*************** End **************/

int main()
{
    int y, m;
    cin >> y >> m;
    printMonth(y, m);
    return 0;
}