using System;
using System.Data;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm9 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default to binding sales records
                RadioButton1.Checked = true;
                BindGrid(true);
            }
        }

        protected void RadioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (RadioButton2.Checked)
            {
                BindGrid(false); // Bind Purchases
            }
        }

        protected void RadioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if (RadioButton1.Checked)
            {
                BindGrid(true); // Bind Sales
            }
        }

        private void BindGrid(bool isSales)
        {
            try
            {
                string query;
                if (isSales)
                {
                    query = @"SELECT s.InvoiceNumber as [Invoice No], c.name as [Customer Name], prod.ProductName as [Product],
                                     s.Quantity as [Qty], s.SellingPrice as [Unit Price ($)], s.Discount as [Discount ($)],
                                     s.Total as [Total Amount ($)], s.SaleDate as [Transaction Date]
                              FROM Sales s
                              INNER JOIN NewCustomer c ON s.CustomerId = c.Id
                              INNER JOIN Products prod ON s.ProductCode = prod.ProductCode
                              ORDER BY s.SaleDate DESC";
                }
                else
                {
                    query = @"SELECT p.PurchaseId as [Purchase ID], s.suppliername as [Supplier Name], prod.ProductName as [Product],
                                     p.Quantity as [Qty], p.PurchasePrice as [Unit Cost ($)], (p.Quantity * p.PurchasePrice) as [Total Cost ($)],
                                     p.PurchaseDate as [Purchase Date]
                              FROM Purchases p
                              INNER JOIN NewSupplier s ON p.SupplierId = s.supplierid
                              INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                              ORDER BY p.PurchaseDate DESC";
                }

                DataSet ds = dc.getdata(query);
                GridView1.DataSource = ds;
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading transaction records: " + ex.Message + "')</script>");
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}