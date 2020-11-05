struct Employee {
   name:String,
   company:String,
   age:u32
}
fn main() {
   //初始化结构体
   let mut emp1 = display();
   //将结构体作为参数传递给 display
   // display(&mut emp1);
   println!("Name is :{} company is {} age is 
   {}",emp1.name,emp1.company,emp1.age); 
}

// 使用点号(.) 访问符访问结构体的元素并输出它么的值
fn display() -> Employee{
   let mut emp1 = Employee {
      company:String::from("TutorialsPoint"),
      name:String::from("Mohtashim"),
      age:50
   };
   return emp1;
   // println!("Name is :{} company is {} age is 
   // {}",(*emp).name,(*emp).company,(*emp).age);
   // (*emp).age = 35;
}