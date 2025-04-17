public class Employee {
    // gender变量可以用布尔值或者整型(方便统计,直接对它做加法操作即可),方便逻辑判断,根据需求设置
    private String name,gender;
    private int id,age;

    // 尽量保持函数参数与成员变量顺序一致
    Employee(String name,String gender,int id,int age){
        this.name = name;
        this.gender = gender;
        this.id = id;
        this.age = age;
    }

    // 这里的this可以省略
    String getName(){
        return this.name;
    }

    String getGender(){
        return this.gender;
    }

    int getId(){
        return this.id;
    }

    int getAge(){
        return this.age;
    }

    // 如果返回值是Employee类型,则可以进行链式调用
    Employee setName(String name){
        this.name = name;
        //调用远程服务,可能是对数据库的操作,可以使用boolean类型判断操作成功还是失败
        // employee.setname(name);
        return this;
    }

    //   Employee setName(String name){
    //     // 链式调用
    //     this.name = name;
    //     //调用远程服务,可能是对数据库的操作,可以使用boolean类型判断操作成功还是失败
    //     employee.setname("张三").setId();
    //     return this;
    // }

    Employee setGender(String gender){
        this.gender = gender;
        return this;
    }

    Employee setId(int id){
        this.id = id;
        return this;
    }

    Employee setAge(int age){
        this.age = age;
        return this;
    }

    @Override
    public String toString(){
        String str = "Employee [name=" + name + ", gender=" + gender + ", id=" + id + ", age=" + age + "]";
        return str;
    }


    
}
