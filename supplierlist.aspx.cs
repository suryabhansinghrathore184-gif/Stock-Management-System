using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            try
            {
                string search = TxtSearch.Text.Trim();
                string status = DdlStatus.SelectedValue;
                string sortBy = DdlSort.SelectedValue;

                string query = "SELECT * FROM NewSupplier WHERE 1=1";
                List<SqlParameter> paramList = new List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (suppliername LIKE @Search OR companyname LIKE @Search OR email LIKE @Search OR supplierid LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }

                if (!string.IsNullOrEmpty(status))
                {
                    query += " AND supplierstatus = @Status";
                    paramList.Add(new SqlParameter("@Status", SqlDbType.VarChar) { Value = status });
                }

                query += " ORDER BY " + sortBy;

                DataSet ds = dc.GetDataSet(query, paramList.ToArray());
                GridView1.DataSource = ds;
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error loading suppliers: " + ex.Message + "');", true);
            }
        }

        protected void BtnApply_Click(object sender, EventArgs e)
        {
            GridView1.PageIndex = 0;
            BindGrid();
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            TxtSearch.Text = "";
            DdlStatus.SelectedIndex = 0;
            DdlSort.SelectedIndex = 0;
            GridView1.PageIndex = 0;
            BindGrid();
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string id = e.CommandArgument.ToString();

            if (e.CommandName == "ToggleStatus")
            {
                try
                {
                    string toggleQuery = "UPDATE NewSupplier SET supplierstatus = CASE WHEN supplierstatus = 'Active' THEN 'Inactive' ELSE 'Active' END WHERE supplierid = @Id";
                    SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                    dc.ExecuteNonQuery(toggleQuery, param);

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Updated!', 'Supplier account status has been toggled.', 'success');", true);
                    BindGrid();
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Error', '" + ex.Message + "', 'error');", true);
                }
            }
            else if (e.CommandName == "DeleteSupplier")
            {
                try
                {
                    // Verify transactions
                    string checkQuery = "SELECT COUNT(*) FROM Purchases WHERE SupplierId = @Id";
                    SqlParameter[] checkParams = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                    int linkedPurchases = Convert.ToInt32(dc.ExecuteScalar(checkQuery, checkParams));

                    if (linkedPurchases > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Cannot Delete!', 'This supplier has active supply history and cannot be deleted.', 'warning');", true);
                        return;
                    }

                    // Verify products supplied
                    string checkProdQuery = "SELECT COUNT(*) FROM Products WHERE SupplierId = @Id";
                    SqlParameter[] checkProdParams = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                    int linkedProducts = Convert.ToInt32(dc.ExecuteScalar(checkProdQuery, checkProdParams));

                    if (linkedProducts > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Cannot Delete!', 'This supplier has catalog items registered in inventory and cannot be deleted.', 'warning');", true);
                        return;
                    }

                    string deleteQuery = "DELETE FROM NewSupplier WHERE supplierid = @Id";
                    SqlParameter[] deleteParams = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                    dc.ExecuteNonQuery(deleteQuery, deleteParams);

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Deleted!', 'Supplier record deleted successfully.', 'success');", true);
                    BindGrid();
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Error', '" + ex.Message + "', 'error');", true);
                }
            }
        }

        protected void BtnExportCSV_Click(object sender, EventArgs e)
        {
            try
            {
                string search = TxtSearch.Text.Trim();
                string status = DdlStatus.SelectedValue;
                string sortBy = DdlSort.SelectedValue;

                string query = @"SELECT supplierid as [Supplier ID], suppliername as [Supplier Name], companyname as [Company],
                                        contactperson as [Contact Person], phonenumber as [Phone], altnumber as [Alt Phone], email as [Email],
                                        website as [Website], address as [Address], city as [City], state as [State],
                                        postalcode as [Postal Code], country as [Country], gstnumber as [GSTIN], pannumber as [PAN],
                                        bankdetails as [Bank Details], supplierstatus as [Status], createddate as [Date Registered]
                                 FROM NewSupplier WHERE 1=1";
                List<SqlParameter> paramList = new List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (suppliername LIKE @Search OR companyname LIKE @Search OR email LIKE @Search OR supplierid LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }

                if (!string.IsNullOrEmpty(status))
                {
                    query += " AND supplierstatus = @Status";
                    paramList.Add(new SqlParameter("@Status", SqlDbType.VarChar) { Value = status });
                }

                query += " ORDER BY " + sortBy;

                DataSet ds = dc.GetDataSet(query, paramList.ToArray());
                DataTable dt = ds.Tables[0];

                StringBuilder sb = new StringBuilder();
                string[] columnNames = new string[dt.Columns.Count];
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    columnNames[i] = dt.Columns[i].ColumnName;
                }
                sb.AppendLine(string.Join(",", columnNames));

                foreach (DataRow row in dt.Rows)
                {
                    string[] fields = new string[dt.Columns.Count];
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        string cellValue = row[i].ToString();
                        if (cellValue.Contains(",") || cellValue.Contains("\""))
                        {
                            cellValue = "\"" + cellValue.Replace("\"", "\"\"") + "\"";
                        }
                        fields[i] = cellValue;
                    }
                    sb.AppendLine(string.Join(",", fields));
                }

                Response.Clear();
                Response.ContentType = "text/csv";
                Response.AddHeader("content-disposition", "attachment;filename=Supplier_Directory_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
                Response.Buffer = true;
                Response.Write(sb.ToString());
                Response.End();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Export failed: " + ex.Message + "');", true);
            }
        }

        protected void GridView1_SelectedIndexChanged2(object sender, EventArgs e)
        {
        }
    }
}