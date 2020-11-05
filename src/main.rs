use postgres::{Client, NoTls, Error};
   
fn connect_databse(conn_string: &String) -> Result<Client, Error> {
   let client = Client::connect(conn_string, NoTls)?;
   return Ok(client);
   //  return Ok(());
}

fn create_table(){

}

fn main() {

   let conn_string = String::from("host=198.13.60.74 port=5433 dbname=wangyifan  user=root password=120912");
   
    // let mut client = connect_databse(&conn_string); //
    let res = connect_databse(&conn_string);
    // let mut client = Client::connect("host=198.13.60.74:5433 user=root", NoTls);
    match res {
        Ok(client) => {println!("Succeeded!");
        let mut client1 = client;
        
        },
        Err(e) => {println!("Error: {}!", e);}
    }

}
