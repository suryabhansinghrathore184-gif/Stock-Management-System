# Enterprise Stock Management System (StockFlow)

A modern, responsive, and secure ASP.NET Web Forms application built on .NET Framework 4.7.2 and SQL Server. This project is a fully functional Stock Management System with transactional calculations, analytics, role-based panel access, and professional UI layouts using Bootstrap 5.

---

## Technical Stack
* **Framework**: ASP.NET Web Forms (.NET Framework 4.7.2)
* **Code-Behind**: C#
* **DataAccess**: ADO.NET (Parameterised Queries, Transaction Management)
* **Database**: MS SQL Server (Express / LocalDB / Standard)
* **Styles & UI**: HTML5, CSS3, Bootstrap 5, FontAwesome Icons, Google Fonts (Outfit)
* **Client Scripts**: JavaScript, Chart.js (Analytics), SweetAlert2 (Dialogs)

---

## Setup & Running the Application

### 1. Database Initialization
This application requires MS SQL Server. The SQL Express instance `.\SQLEXPRESS` is targeted by default.

1. Open your SQL Server Management Studio (SSMS) or command shell.
2. Connect to the local server `.\SQLEXPRESS` using Windows Authentication.
3. If it doesn't exist, create a database named `stock mangement system`:
   ```sql
   CREATE DATABASE [stock mangement system];
   ```
4. Execute the modernization schema script located in the project root:
   * **Script Path**: `D:\ASP.net Viit\StockMangementSystem\schema.sql`
   This script will drop legacy tables, add primary keys to existing tables (`a_login`, `NewCustomer`, `NewSupplier`), create the new relational tables (`Categories`, `Products`, `Purchases`, `Sales`, `StockHistory`), add indexes, and seed rich test data.

### 2. Configuration Settings (`Web.config`)
Verify the database connection string in `Web.config`:
```xml
<connectionStrings>
  <add name="StockDB" connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=stock mangement system;Integrated Security=True;TrustServerCertificate=True" providerName="System.Data.SqlClient" />
</connectionStrings>
```
If you are using a custom SQL Server instance, update the `Data Source` property in the connection string.

### 3. Open and Run in Visual Studio 2022
1. Open the solution file `StockMangementSystem.sln` in **Visual Studio 2022**.
2. Press **Build -> Rebuild Solution** to verify that dependencies compile successfully.
3. Select **IIS Express** (or your browser name) and press **F5** (or the green Play button) to launch the web server and run the site.
4. By default, the application will redirect you to `login.aspx`.

---

## Default User Account Credentials
You can log in as any of the following pre-seeded test roles:

* **Admin Portal**:
  * **Username / ID**: `admin`
  * **Password**: `123`
* **Customer Portal**:
  * **Username / ID**: `101`
  * **Password**: `123`
* **Supplier Portal**:
  * **Username / ID**: `101`
  * **Password**: `123`

---

## Folder Structure
* `categories.aspx` / `categories.aspx.cs` - Category CRUD panel.
* `products.aspx` / `products.aspx.cs` - Product management with image uploads.
* `purchase.aspx` / `purchase.aspx.cs` - Record supplier purchases and auto-increase stock.
* `sell.aspx` / `sell.aspx.cs` - Record sales to customers, calculate GST/discounts, auto-decrease stock.
* `print_invoice.aspx` / `print_invoice.aspx.cs` - Dedicated invoice layout for browser printing.
* `stock.aspx` / `stock.aspx.cs` - Current inventory, stock alerts, and manual adjustment form.
* `dashboard.aspx` / `dashboard.aspx.cs` - Real-time KPIs and trend lines/pie charts (Chart.js).
* `reports.aspx` / `reports.aspx.cs` - Product, customer, supplier, sales, purchase, and profit reporting with print/CSV export options.
* `DataCon.cs` - Central database connection wrapper executing parameterized queries.
* `Site1.Master` - Master page containing the Admin navigation sidebar and navbar.
* `Links/` - Folder containing uploaded product images and user photographs.

---

## Deployment to IIS (Internet Information Services)

To publish this application onto a local IIS server or Windows Server, follow these steps:

### Step 1: Install IIS & ASP.NET Framework
1. Open the Windows Start Menu, search for **Turn Windows features on or off**.
2. Expand **Internet Information Services -> World Wide Web Services -> Application Development Features**.
3. Check **ASP.NET 4.7** or **ASP.NET 4.8** (along with .NET Extensibility, ISAPI Extensions, and ISAPI Filters).
4. Click **OK** and let Windows install the required files.

### Step 2: Publish the Project in Visual Studio
1. Right-click on the `StockMangementSystem` project in the Visual Studio Solution Explorer.
2. Select **Publish**.
3. Choose **Folder** as the target, set a folder path (e.g., `C:\PublishedWebsites\StockFlow`), and click **Publish**.
4. Visual Studio will compile the code and copy only the runtime files (`.aspx`, `bin/*.dll`, `Web.config`, asset folders) to the target directory.

### Step 3: Create Website in IIS Manager
1. Press `Win + R`, type `inetmgr` and press Enter to open the **IIS Manager**.
2. Right-click on **Sites** in the left connections tree and select **Add Website**.
3. Enter site details:
   * **Site name**: `StockFlow`
   * **Physical path**: Navigate to your publish folder (e.g., `C:\PublishedWebsites\StockFlow`).
   * **Binding Port**: Change port (e.g., `8080`) to avoid conflicts with Default Web Site.
4. Click **OK**.

### Step 4: Configure Application Pool
1. Select **Application Pools** in the left sidebar of IIS Manager.
2. Find the application pool for your site (e.g., `StockFlow`).
3. Right-click and choose **Basic Settings**.
4. Ensure the **.NET CLR Version** is set to **.NET CLR Version v4.0.30319** and the **Managed pipeline mode** is set to **Integrated**.

### Step 5: Grant Folder Permissions for Image Uploads
For product image uploads to work, IIS must have write permissions for the `Links` folder:
1. Navigate to the physical website directory (e.g., `C:\PublishedWebsites\StockFlow`).
2. Right-click the `Links` folder and choose **Properties**.
3. Go to the **Security** tab, click **Edit**, and click **Add**.
4. Type `IIS_IUSRS` and click **Check Names**, then click **OK**.
5. Select `IIS_IUSRS` and check **Modify** and **Write** permissions, then click **Apply** and **OK**.
