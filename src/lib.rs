// #[macro_use]
// extern crate diesel;
// extern crate dotenv;

// use diesel::prelude::*;
// use diesel::pg::PgConnection;
// use dotenv::dotenv;
// use std::env;

// pub fn establish_connection() -> PgConnection {
//     dotenv().ok();

//     let database_url = env::var("DATABASE_URL")
//         .expect("DATABASE_URL must be set");
//     PgConnection::establish(&database_url)
//         .expect(&format!("Error connecting to {}", database_url));
//     diesel::sql_query("SELECT * FROM users WHERE id > & AND name <> ?")
//     .bind::<Integer, _>(1) // bind i8 to Integer
//     .bind::<Text, _>("Tess") // bind &str to Text
//     .get_results(&connection); // define &connection
// }