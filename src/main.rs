use postgres::{Client, NoTls, Error};
use tokio_postgres::{Row, SimpleQueryMessage, Socket};
   
fn connect_database(conn_string: &str) -> postgres::Client {
   return Client::connect(&conn_string, NoTls).expect("Failed to connect database!");
}

fn execute_sql(client: &mut Client, sql_string: &str) -> u64{
    return client.execute(sql_string, &[]).expect("Failed to execute SQL statements!");
}

fn query_sql(client: &mut Client, sql_string: &str) -> Vec<Row> {
    return client.query(sql_string, &[]).expect("Failed to query SQL statements!");
}

fn main() {

    let conn_string = "host=198.13.60.74 port=5433 dbname=wangyifan  user=root password=120912";
    let mut client = connect_database(conn_string);

    let sql_string ="INSERT
                    INTO author
                    VALUES('1', 'wangyifan','china')
                    ";
    // execute_sql(&mut client, sql_string);
    
    let sql_string = "SELECT * FROM author;";
    let rows = query_sql(&mut client, sql_string);
    for row in rows {
    let id: i32 = row.get(0);
    let name: &str = row.get(1);
    let country: &str = row.get(2);

    println!("found person: {} {} {:?}", id, name, country);
    }


}
