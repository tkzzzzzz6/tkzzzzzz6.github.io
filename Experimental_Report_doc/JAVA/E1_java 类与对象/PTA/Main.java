import java.util.Scanner;

class Person {
    private String name;
    private int age;
    private boolean gender;
    private int id;

    // 类变量
    private static int CNT = 0;

    // 无参构造函数
    public Person() {
        System.out.println("This is constructor");
    }

    // 有参构造函数
    public Person(String name, boolean gender, int age) {
        this.name = name;
        this.gender = gender;
        this.age = age;
    }

    // 初始化块
    {
        id = CNT++;
        System.out.println("This is initialization block, id is " + id);
    }

    // 静态初始化块
    static {
        System.out.println("This is static initialization block");
    }
    // Get方法
    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public boolean getGender() {
        return gender;
    }

    public int getId() {
        return id;
    }

    // 方法
    @Override
    public String toString() {
        return "Person [name=" + name + ", age=" + age + ", gender=" + gender + ", id=" + id + "]";
    }
}

public class Main {
    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            int n = sc.nextInt();
            if (n <= 0) {
                System.out.println("Please enter a positive number");
                return;
            }
            sc.nextLine();

            Person[] persons = new Person[n];

            try {
                for (int i = 0; i < n; ++i) {
                    String input = sc.nextLine();
                    String[] parts = input.split(" ");
                    if (parts.length < 3) {
                        System.out.println("Invalid input format. Please provide: name age gender");
                        return;
                    }
                    String name = parts[0];
                    int age = Integer.parseInt(parts[1]);
                    boolean gender = Boolean.parseBoolean(parts[2]);
                    persons[i] = new Person(name, gender, age);
                }

                for (int i = n - 1; i >= 0; --i) {
                    System.out.println(persons[i]);
                }
                
                // 使用无参构造函数新建一个Person对象，然后直接打印该对象
                Person p = new Person();
                System.out.println(p.getName() + "," + p.getAge() + "," + p.getGender() + "," + p.getId());
                System.out.println(p);
            } catch (NumberFormatException e) {
                System.out.println("Invalid number format");
            }
        }
    }
}
