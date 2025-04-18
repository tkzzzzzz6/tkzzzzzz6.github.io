// �������ڼ� ?

// �������룺2016 1 Ԥ������� 2016��1��1��������5

// �������룺 2017 7 Ԥ������� 2017��7��1��������6

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
    // �����2000��1��1�յ�Ŀ�����ڵ�������
    int days = 0;

    // �������������
    for (int y = 2000; y < year; y++)
    {
        days += leapYear(y) ? 366 : 365;
    }

    // ���㵱���·ݵ�����
    for (int m = 1; m < month; m++)
    {
        if (m == 2)
            days += leapYear(year) ? 29 : 28;
        else if (m == 4 || m == 6 || m == 9 || m == 11)
            days += 30;
        else
            days += 31;
    }

    // 2000��1��1����������(6)
    return (days + 6) % 7;
    /********** End **********/
}

int main()
{
    int y, m, xq;
    cin >> y >> m;

    xq = whatDay(y, m);

    cout << y << "��" << m << "��1��������";
    if (xq == 7)
        cout << "��" << endl;
    else
        cout << xq << endl;
    return 0;
}