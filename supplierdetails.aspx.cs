using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class supplierdetails : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (string.IsNullOrEmpty(id))
                {
                    Response.Redirect("supplierlist.aspx");
                    return;
                }
                LnkEdit.NavigateUrl = "editsupplier.aspx?id=" + id;
                LoadSupplierDetails(id);
                LoadSupplierStats(id);
                BindHistoryGrid(id);
                BindProductsGrid(id);
            }
        }

        private void LoadSupplierDetails(string id)
        {
            try
            {
                string query = "SELECT * FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                DataSet ds = dc.GetDataSet(query, param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    LblId.Text = row["supplierid"].ToString();
                    LblName.Text = row["suppliername"].ToString();
                    LblCompany.Text = row["companyname"].ToString();
                    LblContact.Text = string.IsNullOrEmpty(row["contactperson"].ToString()) ? "-" : row["contactperson"].ToString();
                    LblPhone.Text = row["phonenumber"].ToString();
                    LblAltPhone.Text = string.IsNullOrEmpty(row["altnumber"].ToString()) ? "-" : row["altnumber"].ToString();
                    LblEmail.Text = row["email"].ToString();
                    LblWebsite.Text = string.IsNullOrEmpty(row["website"].ToString()) ? "-" : row["website"].ToString();
                    LblAddress.Text = row["address"].ToString();
                    LblCity.Text = row["city"].ToString();
                    LblState.Text = string.IsNullOrEmpty(row["state"].ToString()) ? "-" : row["state"].ToString();
                    LblPostal.Text = string.IsNullOrEmpty(row["postalcode"].ToString()) ? "-" : row["postalcode"].ToString();
                    LblCountry.Text = string.IsNullOrEmpty(row["country"].ToString()) ? "India" : row["country"].ToString();
                    LblGst.Text = string.IsNullOrEmpty(row["gstnumber"].ToString()) ? "N/A" : row["gstnumber"].ToString();
                    LblPan.Text = string.IsNullOrEmpty(row["pannumber"].ToString()) ? "N/A" : row["pannumber"].ToString();
                    LblStatus.Text = row["supplierstatus"].ToString();
                    LblBank.Text = string.IsNullOrEmpty(row["bankdetails"].ToString()) ? "-" : row["bankdetails"].ToString();

                    DateTime created;
                    if (row["createddate"] != DBNull.Value && DateTime.TryParse(row["createddate"].ToString(), out created))
                    {
                        LblCreatedDate.Text = created.ToString("dd-MM-yyyy");
                    }
                    else
                    {
                        LblCreatedDate.Text = "-";
                    }

                    string photo = row["supplierphoto"].ToString();
                    if (!string.IsNullOrEmpty(photo))
                    {
                        ImgPhoto.ImageUrl = "/Links/" + photo;
                    }
                    else
                    {
                        ImgPhoto.ImageUrl = "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=120&q=80";
                    }
                }
                else
                {
                    Response.Redirect("supplierlist.aspx");
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading profile: " + ex.Message + "')</script>");
            }
        }

        private void LoadSupplierStats(string id)
        {
            try
            {
                // Total Shipments count
                string countQuery = "SELECT COUNT(*) FROM Purchases WHERE SupplierId = @Id";
                SqlParameter[] param1 = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                object count = dc.ExecuteScalar(countQuery, param1);
                LblTotalPurchases.Text = count != null ? count.ToString() : "0";

                // Total Cost paid
                string sumQuery = "SELECT SUM(Quantity * PurchasePrice) FROM Purchases WHERE SupplierId = @Id";
                SqlParameter[] param2 = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                object spent = dc.ExecuteScalar(sumQuery, param2);
                LblTotalSpent.Text = spent != null && spent != DBNull.Value ? Convert.ToDecimal(spent).ToString("N2") : "0.00";

                // Last Active Date
                string dateQuery = "SELECT MAX(PurchaseDate) FROM Purchases WHERE SupplierId = @Id";
                SqlParameter[] param3 = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                object date = dc.ExecuteScalar(dateQuery, param3);
                
                DateTime lastDate;
                if (date != null && date != DBNull.Value && DateTime.TryParse(date.ToString(), out lastDate))
                {
                    LblLastPurchaseDate.Text = lastDate.ToString("dd-MM-yyyy");
                }
                else
                {
                    LblLastPurchaseDate.Text = "-";
                }
            }
            catch
            {
                LblTotalPurchases.Text = "0";
                LblTotalSpent.Text = "0.00";
                LblLastPurchaseDate.Text = "-";
            }
        }

        private void BindHistoryGrid(string id)
        {
            try
            {
                string query = @"SELECT p.PurchaseId, p.Quantity, p.PurchasePrice, p.PurchaseDate, prod.ProductName
                                FROM Purchases p
                                INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                                WHERE p.SupplierId = @Id
                                ORDER BY p.PurchaseDate DESC, p.PurchaseId DESC";

                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                DataSet ds = dc.GetDataSet(query, param);
                GridHistory.DataSource = ds;
                GridHistory.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading purchases: " + ex.Message + "')</script>");
            }
        }

        private void BindProductsGrid(string id)
        {
            try
            {
                string query = @"SELECT ProductCode, ProductName, PurchasePrice, SellingPrice, Quantity
                                FROM Products
                                WHERE SupplierId = @Id
                                ORDER BY ProductName ASC";

                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                DataSet ds = dc.GetDataSet(query, param);
                GridProducts.DataSource = ds;
                GridProducts.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading products: " + ex.Message + "')</script>");
            }
        }

        protected void GridHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridHistory.PageIndex = e.NewPageIndex;
            BindHistoryGrid(Request.QueryString["id"]);
        }

        protected void GridProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridProducts.PageIndex = e.NewPageIndex;
            BindProductsGrid(Request.QueryString["id"]);
        }
    }
}
