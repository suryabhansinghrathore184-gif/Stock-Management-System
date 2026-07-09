using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class c_wishlist : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindWishlist();
                BindCatalog();
            }
        }

        private void BindWishlist()
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = @"SELECT w.ProductCode, p.ProductName, p.SellingPrice, p.Quantity 
                                 FROM CustomerWishlist w
                                 INNER JOIN Products p ON w.ProductCode = p.ProductCode
                                 WHERE w.CustomerId = @CustomerId";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@CustomerId", cid) };
                GvWishlist.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvWishlist.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading wishlist: " + ex.Message);
            }
        }

        private void BindCatalog()
        {
            try
            {
                string query = "SELECT ProductCode, ProductName, SellingPrice, Quantity FROM Products ORDER BY ProductName";
                GvCatalog.DataSource = dc.GetDataSet(query).Tables[0];
                GvCatalog.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading catalog: " + ex.Message);
            }
        }

        protected void GvWishlist_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string productCode = e.CommandArgument.ToString();
            string cid = Session["cid"].ToString();

            if (e.CommandName == "RemoveWish")
            {
                try
                {
                    string query = "DELETE FROM CustomerWishlist WHERE CustomerId = @CustomerId AND ProductCode = @ProductCode";
                    SqlParameter[] param = new SqlParameter[]
                    {
                        new SqlParameter("@CustomerId", cid),
                        new SqlParameter("@ProductCode", productCode)
                    };
                    dc.ExecuteNonQuery(query, param);
                    ShowAlert("Product removed from wishlist.");
                    BindWishlist();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error: " + ex.Message);
                }
            }
            else if (e.CommandName == "BuyItem")
            {
                try
                {
                    // 1. Fetch Product Info
                    string pQuery = "SELECT ProductName, SellingPrice, Quantity FROM Products WHERE ProductCode = @ProductCode";
                    SqlParameter[] pParam = new SqlParameter[] { new SqlParameter("@ProductCode", productCode) };
                    DataSet ds = dc.GetDataSet(pQuery, pParam);

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataRow row = ds.Tables[0].Rows[0];
                        int currentQty = Convert.ToInt32(row["Quantity"]);
                        decimal price = Convert.ToDecimal(row["SellingPrice"]);

                        if (currentQty < 1)
                        {
                            ShowAlert("This product is currently out of stock!");
                            return;
                        }

                        // 2. Perform Transaction
                        string invoice = "INV-SIM-" + DateTime.Now.ToString("yyyyMMddHHmmss");
                        decimal gst = 18; // Default GST 18%
                        decimal total = price * 1.18m; // Simple total including GST

                        // Insert Sales
                        string sInsert = @"INSERT INTO Sales (InvoiceNumber, CustomerId, ProductCode, Quantity, SellingPrice, Discount, GST, Total, SaleDate, OrderStatus) 
                                           VALUES (@Invoice, @CustomerId, @ProductCode, 1, @Price, 0.00, @GST, @Total, GETDATE(), 'Completed')";
                        SqlParameter[] sParams = new SqlParameter[]
                        {
                            new SqlParameter("@Invoice", invoice),
                            new SqlParameter("@CustomerId", cid),
                            new SqlParameter("@ProductCode", productCode),
                            new SqlParameter("@Price", price),
                            new SqlParameter("@GST", gst),
                            new SqlParameter("@Total", total)
                        };
                        dc.ExecuteNonQuery(sInsert, sParams);

                        // Update Product Quantity
                        string pUpdate = "UPDATE Products SET Quantity = Quantity - 1 WHERE ProductCode = @ProductCode";
                        dc.ExecuteNonQuery(pUpdate, new SqlParameter[] { new SqlParameter("@ProductCode", productCode) });

                        // Log Stock History
                        string hInsert = "INSERT INTO StockHistory (ProductCode, ChangeType, Quantity, Remarks, ChangeDate) VALUES (@ProductCode, 'Sale', 1, @Remarks, GETDATE())";
                        dc.ExecuteNonQuery(hInsert, new SqlParameter[]
                        {
                            new SqlParameter("@ProductCode", productCode),
                            new SqlParameter("@Remarks", "Customer direct simulated wishlist purchase (Invoice: " + invoice + ")")
                        });

                        // Remove from wishlist
                        string wDelete = "DELETE FROM CustomerWishlist WHERE CustomerId = @CustomerId AND ProductCode = @ProductCode";
                        dc.ExecuteNonQuery(wDelete, new SqlParameter[]
                        {
                            new SqlParameter("@CustomerId", cid),
                            new SqlParameter("@ProductCode", productCode)
                        });

                        // Notify
                        string nInsert = "INSERT INTO CustomerNotifications (UserId, UserRole, Title, Message, IsRead, CreatedDate) VALUES (@CustomerId, 'Customer', 'Order Confirmed', @Message, 0, GETDATE())";
                        dc.ExecuteNonQuery(nInsert, new SqlParameter[]
                        {
                            new SqlParameter("@CustomerId", cid),
                            new SqlParameter("@Message", "Your order for " + row["ProductName"].ToString() + " (Invoice: " + invoice + ") has been processed successfully!")
                        });

                        ShowAlert("Purchase successful! Invoice generated: " + invoice);
                        BindWishlist();
                        BindCatalog();
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Transaction failed: " + ex.Message);
                }
            }
        }

        protected void GvCatalog_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AddWish")
            {
                string productCode = e.CommandArgument.ToString();
                string cid = Session["cid"].ToString();

                try
                {
                    // Check duplicate
                    string checkQuery = "SELECT COUNT(*) FROM CustomerWishlist WHERE CustomerId = @CustomerId AND ProductCode = @ProductCode";
                    SqlParameter[] checkParam = new SqlParameter[]
                    {
                        new SqlParameter("@CustomerId", cid),
                        new SqlParameter("@ProductCode", productCode)
                    };
                    int exists = Convert.ToInt32(dc.ExecuteScalar(checkQuery, checkParam));

                    if (exists > 0)
                    {
                        ShowAlert("This product is already in your wishlist!");
                        return;
                    }

                    // Insert wishlist
                    string insertQuery = "INSERT INTO CustomerWishlist (CustomerId, ProductCode, AddedDate) VALUES (@CustomerId, @ProductCode, GETDATE())";
                    dc.ExecuteNonQuery(insertQuery, checkParam);

                    ShowAlert("Product added to wishlist!");
                    BindWishlist();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error: " + ex.Message);
                }
            }
        }

        protected void GvCatalog_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GvCatalog.PageIndex = e.NewPageIndex;
            BindCatalog();
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}
