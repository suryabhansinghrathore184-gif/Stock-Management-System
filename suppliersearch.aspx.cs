using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string id = TextBox1.Text.Trim();
            if (string.IsNullOrEmpty(id)) return;

            try
            {
                string query = "SELECT * FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    ClearFields();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Not Found', 'No supplier found with this ID.', 'warning');", true);
                }
                else
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    Image1.ImageUrl = string.IsNullOrEmpty(row[0].ToString()) ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80" : "/Links/" + row[0].ToString();

                    TextBox1.Text = row[1].ToString();
                    Label2.Text = row[2].ToString();
                    Label3.Text = row[3].ToString();
                    Label4.Text = row[4].ToString();
                    Label5.Text = row[5].ToString();
                    Label6.Text = row[6].ToString();
                    Label7.Text = row[7].ToString();
                    Label9.Text = row[8].ToString();
                    Label10.Text = row[9].ToString();
                    Label11.Text = row[10].ToString();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error searching supplier: " + ex.Message + "')</script>");
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            string id = TextBox1.Text.Trim();
            if (string.IsNullOrEmpty(id)) return;

            try
            {
                // Verify if supplier has transactions
                string checkQuery = "SELECT COUNT(1) FROM Purchases WHERE SupplierId = @Id";
                SqlParameter[] checkParams = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };
                int linkedTransactions = Convert.ToInt32(dc.ExecuteScalar(checkQuery, checkParams));
                if (linkedTransactions > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Cannot Delete!', 'This supplier has active supply history and cannot be deleted.', 'error');", true);
                    return;
                }

                string deleteQuery = "DELETE FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] deleteParams = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };
                dc.ExecuteNonQuery(deleteQuery, deleteParams);

                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Deleted!', 'Supplier record deleted.', 'success');", true);
                ClearFields();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error deleting supplier: " + ex.Message + "')</script>");
            }
        }

        private void ClearFields()
        {
            TextBox1.Text = "";
            Label2.Text = "";
            Label3.Text = "";
            Label4.Text = "";
            Label5.Text = "";
            Label6.Text = "";
            Label7.Text = "";
            Label9.Text = "";
            Label10.Text = "";
            Label11.Text = "";
            Image1.ImageUrl = "";
        }
    }
}