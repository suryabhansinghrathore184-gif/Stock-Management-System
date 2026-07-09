# How to Deploy to Somee.com (Free ASP.NET Hosting)

Follow these steps to deploy your Stock Management System to Somee.com:

---

## 1. Create a Free Account & Website
1. Go to [Somee.com](https://somee.com) and register a free account.
2. In the Left Menu, click **Websites** -> **Create new website**.
3. Choose a free subdomain (e.g. `yourname-sms.somee.com`) and choose **ASP.NET version 4.7/4.8**.

---

## 2. Create your SQL Server Database
1. In the Left Menu, click **Databases** -> **Create MS SQL Database**.
2. Select database version (e.g. MS SQL 2019/2022).
3. Choose a database name (e.g. `StockFlowDB`) and click **Create**.
4. Note down your database credentials:
   - **Host Name/Server**: (e.g. `mssql15.somee.com`)
   - **Database Name**: (e.g. `StockFlowDB`)
   - **Database User**: (e.g. `youruser_db`)
   - **Database Password**: (e.g. `yourpwd123`)

---

## 3. Run the Database Script
1. In the Somee database page, open the **SQL Query Runner** tool (or connect via SQL Server Management Studio using your credentials).
2. Open **[schema.sql](file:///D:/ASP.net%20Viit/StockMangementSystem/schema.sql)**.
3. Copy all SQL text, paste it into the Query box, and click **Execute**.

---

## 4. Configure `Web.config` Connection String
Open your published **`Web.config`** file located inside:
`D:\ASP.net Viit\StockMangementSystem\obj\Release\Package\PackageTmp\Web.config`

Replace the connection string line:
```xml
<connectionStrings>
  <add name="StockDB" connectionString="Workstation ID=YOUR_SERVER;packet size=4096;user id=YOUR_USER;data source=YOUR_SERVER;persist security info=False;initial catalog=YOUR_DATABASE;password=YOUR_PASSWORD" providerName="System.Data.SqlClient" />
</connectionStrings>
```
Substitute your Somee database values into the fields above:
* Replace `YOUR_SERVER` with the host name (e.g., `mssql15.somee.com`).
* Replace `YOUR_DATABASE` with your database name.
* Replace `YOUR_USER` with the database username.
* Replace `YOUR_PASSWORD` with the database password.

---

## 5. Upload files
1. Go to Somee **Websites** -> **File Manager**.
2. Click **Upload Zip Archive**.
3. Upload the compiled ZIP file from your computer:
   `D:\ASP.net Viit\StockMangementSystem\obj\Release\Package\StockMangementSystem.zip`
4. Click **Extract** to deploy all files.
5. Visit your new live subdomain (e.g. `http://yourname-sms.somee.com`)!
