use postgres::{Client, NoTls, Error};
   
fn connect_database(conn_string: String) -> postgres::Client {
   return Client::connect(&conn_string, NoTls).expect("Failed to connect database!,{}");
}
fn execute_sql(client: &mut Client, sql_string: &str) -> u64{
    return client.execute(sql_string, &[]).expect("Failed to execute SQL statements");
}

fn main() {

    let conn_string = String::from("host=198.13.60.74 port=5433 dbname=wangyifan  user=root password=120912");
    let mut client = connect_database(conn_string);
    // let sql_string = String::from("CREATE TABLE IF NOT EXISTS author (
    //                 id              SERIAL PRIMARY KEY,
    //                 name            VARCHAR NOT NULL,
    //                 country         VARCHAR NOT NULL
    //               )");
    let sql_string = "CREATE TABLE IF NOT EXISTS author1 (
                    id              SERIAL PRIMARY KEY,
                    name            VARCHAR NOT NULL,
                    country         VARCHAR NOT NULL
                  )";
    execute_sql(&mut client, sql_string);


}
