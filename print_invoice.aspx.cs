using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class print_invoice : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string invoiceNo = Request.QueryString["invoice"];
                if (string.IsNullOrEmpty(invoiceNo))
                {
                    Response.Write("<h3>Error: Invoice number is missing.</h3>");
                    Response.End();
                    return;
                }

                LoadInvoiceDetails(invoiceNo);
            }
        }

        private void LoadInvoiceDetails(string invoiceNo)
        {
            try
            {
                string query = @"SELECT s.InvoiceNumber, s.Quantity, s.SellingPrice, s.Discount, s.GST, s.Total, s.SaleDate, s.ProductCode, s.CustomerId,
                                       c.name as customername, c.number as customerphone, c.email as customeremail, c.address as customeraddress, c.gstnumber as customergst,
                                       p.ProductName
                                FROM Sales s
                                INNER JOIN NewCustomer c ON s.CustomerId = c.Id
                                INNER JOIN Products p ON s.ProductCode = p.ProductCode
                                WHERE s.InvoiceNumber = @InvoiceNumber";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@InvoiceNumber", SqlDbType.VarChar) { Value = invoiceNo }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    // Invoice Info
                    LblInvoiceNumber.Text = row["InvoiceNumber"].ToString();
                    LblInvoiceDate.Text = Convert.ToDateTime(row["SaleDate"]).ToString("dd-MM-yyyy hh:mm tt");

                    // Customer Info
                    LblCustId.Text = row["CustomerId"].ToString();
                    LblCustName.Text = row["customername"].ToString();
                    LblCustPhone.Text = row["customerphone"].ToString();
                    LblCustEmail.Text = row["customeremail"].ToString();
                    LblCustAddress.Text = row["customeraddress"].ToString();
                    LblCustGst.Text = string.IsNullOrEmpty(row["customergst"].ToString()) ? "N/A" : row["customergst"].ToString();

                    // Product Line
                    decimal price = Convert.ToDecimal(row["SellingPrice"]);
                    int qty = Convert.ToInt32(row["Quantity"]);
                    decimal subtotal = price * qty;
                    decimal discount = Convert.ToDecimal(row["Discount"]);
                    decimal gstRate = Convert.ToDecimal(row["GST"]);

                    LblItemCode.Text = row["ProductCode"].ToString();
                    LblItemName.Text = row["ProductName"].ToString();
                    LblPrice.Text = price.ToString("N2");
                    LblQty.Text = qty.ToString();
                    LblSubtotal.Text = subtotal.ToString("N2");

                    // Invoice Calculations
                    decimal netSubtotal = subtotal - discount;
                    if (netSubtotal < 0) netSubtotal = 0;
                    decimal gstAmount = netSubtotal * (gstRate / 100);
                    decimal grandTotal = Convert.ToDecimal(row["Total"]);

                    LblSummarySubtotal.Text = subtotal.ToString("N2");
                    LblSummaryDiscount.Text = discount.ToString("N2");
                    LblGstRate.Text = gstRate.ToString("0.##");
                    LblSummaryGst.Text = gstAmount.ToString("N2");
                    LblSummaryGrandTotal.Text = grandTotal.ToString("N2");
                }
                else
                {
                    Response.Write("<h3>Error: Invoice details not found.</h3>");
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<h3>An error occurred loading the invoice: " + ex.Message + "</h3>");
                Response.End();
            }
        }
    }
}
