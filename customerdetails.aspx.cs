using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class customerdetails : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (string.IsNullOrEmpty(id))
                {
                    Response.Redirect("customerlist.aspx");
                    return;
                }
                LnkEdit.NavigateUrl = "editcustomer.aspx?id=" + id;
                LoadCustomerDetails(id);
                LoadCustomerStats(id);
                BindHistoryGrid(id);
            }
        }

        private void LoadCustomerDetails(string id)
        {
            try
            {
                string query = "SELECT * FROM NewCustomer WHERE Id = @Id";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                DataSet ds = dc.GetDataSet(query, param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    LblId.Text = row["Id"].ToString();
                    LblName.Text = row["name"].ToString();
                    LblPhone.Text = row["number"].ToString();
                    LblAltPhone.Text = string.IsNullOrEmpty(row["altmobile"].ToString()) ? "-" : row["altmobile"].ToString();
                    LblEmail.Text = row["email"].ToString();
                    LblCompany.Text = string.IsNullOrEmpty(row["companyname"].ToString()) ? "-" : row["companyname"].ToString();
                    LblAddress.Text = row["address"].ToString();
                    LblCity.Text = row["city"].ToString();
                    LblState.Text = string.IsNullOrEmpty(row["state"].ToString()) ? "-" : row["state"].ToString();
                    LblPostal.Text = string.IsNullOrEmpty(row["postalcode"].ToString()) ? "-" : row["postalcode"].ToString();
                    LblCountry.Text = string.IsNullOrEmpty(row["country"].ToString()) ? "India" : row["country"].ToString();
                    LblGst.Text = string.IsNullOrEmpty(row["gstnumber"].ToString()) ? "N/A" : row["gstnumber"].ToString();
                    LblType.Text = row["customertype"].ToString();
                    LblStatus.Text = row["status"].ToString();
                    
                    DateTime created;
                    if (row["createddate"] != DBNull.Value && DateTime.TryParse(row["createddate"].ToString(), out created))
                    {
                        LblCreatedDate.Text = created.ToString("dd-MM-yyyy");
                    }
                    else
                    {
                        LblCreatedDate.Text = "-";
                    }

                    string photo = row["photolink"].ToString();
                    if (!string.IsNullOrEmpty(photo))
                    {
                        ImgPhoto.ImageUrl = "/Links/" + photo;
                    }
                    else
                    {
                        ImgPhoto.ImageUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=120&q=80";
                    }
                }
                else
                {
                    Response.Redirect("customerlist.aspx");
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading profile: " + ex.Message + "')</script>");
            }
        }

        private void LoadCustomerStats(string id)
        {
            try
            {
                // Total Orders
                string orderQuery = "SELECT COUNT(DISTINCT InvoiceNumber) FROM Sales WHERE CustomerId = @Id";
                SqlParameter[] param1 = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                object orders = dc.ExecuteScalar(orderQuery, param1);
                LblTotalOrders.Text = orders != null ? orders.ToString() : "0";

                // Total Spent
                string spentQuery = "SELECT SUM(Total) FROM Sales WHERE CustomerId = @Id";
                SqlParameter[] param2 = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                object spent = dc.ExecuteScalar(spentQuery, param2);
                LblTotalSpent.Text = spent != null && spent != DBNull.Value ? Convert.ToDecimal(spent).ToString("N2") : "0.00";
            }
            catch
            {
                LblTotalOrders.Text = "0";
                LblTotalSpent.Text = "0.00";
            }
        }

        private void BindHistoryGrid(string id)
        {
            try
            {
                string query = @"SELECT s.InvoiceNumber, s.Quantity, s.SellingPrice, s.Discount, s.Total, s.SaleDate, p.ProductName
                                FROM Sales s
                                INNER JOIN Products p ON s.ProductCode = p.ProductCode
                                WHERE s.CustomerId = @Id
                                ORDER BY s.SaleDate DESC, s.SaleId DESC";

                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                DataSet ds = dc.GetDataSet(query, param);
                GridHistory.DataSource = ds;
                GridHistory.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading sales logs: " + ex.Message + "')</script>");
            }
        }

        protected void GridHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridHistory.PageIndex = e.NewPageIndex;
            BindHistoryGrid(Request.QueryString["id"]);
        }
    }
}
