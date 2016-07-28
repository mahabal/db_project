This project was meant to be run on Linux. (Arch Linux setup and installation will be provided here).

**Prerequisites**

   - MariaDB (Installation and Setup)
    
   * Download the MariaDB package:
 
        pacman -S mariadb --noconfirm
        
   * Setup MariaDB using: 
           
        mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    
   * Set the root password to be "b&" using:
            
        mysql -u root password "b&"
         
   * Import the blank schema into mysql    
            
       * For a completely blank schema:
     
            mysql -u root -p < schema.sql
        
        * For a schema that has a university and an admin account
                  
                 mysql -u root -p < schema_wiped_admin.sql
                 Admin information: matt:password

- Gradle (optional: if you want to compile it yourself)


*Compiling (optional)*

- Use terminal to enter the directory
    
- Execute the following command:

      gradle compileJava

**Running**

   - Start the backend with: 
    
    java -jar backend.jar
    
   - Navigate to the directory:

    src/main/resources/html/

  - Launch the file: 
  
      index.html

