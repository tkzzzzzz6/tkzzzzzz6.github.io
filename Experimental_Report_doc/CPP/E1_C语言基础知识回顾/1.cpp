// 两个数的对调
// 测试输入：2 5 8 4 3 6 1 9 7 10 预期输出：1 5 8 4 3 6 2 9 7 10

// 测试输入：2 5 10 4 1 6 3 9 7 8 预期输出：1 5 8 4 2 6 3 9 7 10
#include <iostream>
    using namespace std;

void input(int array[]);         // 此函数实现输入10个元素
void max_min_value(int array[]); // 此函数实现交换数组的对应元素
void output(int array[]);        // 此函数实现输出10个元素

int main()
{
    int array[10];
    input(array);
    max_min_value(array);
    output(array);
    return 0;
}

void input(int array[])
{
    // 输入10个整数存储到数组array中
    /********** Begin *********/
    for (int i = 0; i < 10; i++)
    {
        cin >> array[i];
    }

    /********** End **********/
}

void max_min_value(int array[])
{
    // 交换数组对应元素
    /*********************Begin*************/
    int max_index = 0;
    int min_index = 0;
    for (int i = 0; i < 10; i++)
    {
        if (array[i] > array[max_index])
            max_index = i;
        if (array[i] < array[min_index])
            min_index = i;
    }
    swap(array[0], array[min_index]);
    swap(array[9], array[max_index]);
    /*********************End****************/
}

void output(int array[])
{
    // 输出数组中的10个整数
    /**************Begin*************/
    for (int i = 0; i < 10; i++)
    {
        cout << array[i] << " ";
    }
    /************End****************/
}

