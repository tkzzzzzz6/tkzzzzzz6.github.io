import  java.util.Scanner;
class Student{
    private  String name,gender;
    private  int score;
    private  boolean award;

    // 尽量保持函数参数与成员变量顺序一致
    Student(String name,String gender,int score,boolean award){
        this.name=name;
        this.gender=gender;
        this.score=score;
        this.award=award;
    }
    public String getName(){
         return this.name;
     }
    Student setName(String name){
        this.name=name;
        return this;
    }
      public String getGender(){
         return this.gender;
     }
    Student setGender(String gender){
        this.gender=gender;
        return this;
    }
     public int getScore(){
         return this.score;
     }
    Student setScore(int score){
        this.score=score;
        return this;
    }
    public  boolean getAward(){
         return this.award;
     }
    Student setAward(boolean award){
        this.award=award;
        return this;
    }
    @Override
    public String toString(){
        return "Student [name="+name+", gender="+gender+", score="+score+", award="+award+"]";
    }
}

public class Main{
    public static void main(String[] args) {
        Scanner sc=new Scanner(System.in);
        String name=sc.next();
        String gender=sc.next();
        int score=sc.nextInt();
        boolean award=sc.nextBoolean();
        Student a=new Student(name,gender,score,award);
        System.out.println(a.toString());
        
    }
}

