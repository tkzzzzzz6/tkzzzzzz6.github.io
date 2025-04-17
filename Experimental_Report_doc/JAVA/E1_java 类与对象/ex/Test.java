public class Test {
    public static void main(String[] args) {
        String name = "张三";
        String gender = "男";
        int id = 202300001;
        int age = 22;
        Employee employee = new Employee(name,gender,id,age);
        System.out.println(employee);
        employee.setName("谭棵").setGender("男").setId(202306630).setAge(21);
        System.out.println(employee);
    }
}