using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class categories : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid(string search = "")
        {
            try
            {
                string query = "SELECT * FROM Categories";
                SqlParameter[] parameters = null;

                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE CategoryName LIKE @Search";
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" }
                    };
                }

                query += " ORDER BY CategoryName ASC";
                DataSet ds = dc.GetDataSet(query, parameters);
                GridCategories.DataSource = ds;
                GridCategories.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading categories: " + ex.Message);
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string categoryName = TxtCategoryName.Text.Trim();
            string description = TxtDescription.Text.Trim();
            string status = DdlStatus.SelectedValue;
            bool isEdit = !string.IsNullOrEmpty(CategoryIdHidden.Value);

            if (string.IsNullOrEmpty(categoryName))
            {
                ShowAlert("Category Name is required.");
                return;
            }

            try
            {
                // Duplicate check
                string checkQuery = "SELECT COUNT(*) FROM Categories WHERE CategoryName = @CategoryName";
                if (isEdit)
                {
                    checkQuery += " AND CategoryId != @CategoryId";
                }

                SqlParameter[] checkParams;
                if (isEdit)
                {
                    checkParams = new SqlParameter[]
                    {
                        new SqlParameter("@CategoryName", SqlDbType.VarChar) { Value = categoryName },
                        new SqlParameter("@CategoryId", SqlDbType.Int) { Value = Convert.ToInt32(CategoryIdHidden.Value) }
                    };
                }
                else
                {
                    checkParams = new SqlParameter[]
                    {
                        new SqlParameter("@CategoryName", SqlDbType.VarChar) { Value = categoryName }
                    };
                }

                int exists = Convert.ToInt32(dc.ExecuteScalar(checkQuery, checkParams));
                if (exists > 0)
                {
                    ShowAlert("A category with this name already exists.");
                    return;
                }

                // Insert or Update
                if (isEdit)
                {
                    string updateQuery = "UPDATE Categories SET CategoryName = @CategoryName, Description = @Description, Status = @Status WHERE CategoryId = @CategoryId";
                    SqlParameter[] updateParams = new SqlParameter[]
                    {
                        new SqlParameter("@CategoryName", SqlDbType.VarChar) { Value = categoryName },
                        new SqlParameter("@Description", SqlDbType.VarChar) { Value = description },
                        new SqlParameter("@Status", SqlDbType.VarChar) { Value = status },
                        new SqlParameter("@CategoryId", SqlDbType.Int) { Value = Convert.ToInt32(CategoryIdHidden.Value) }
                    };
                    dc.ExecuteNonQuery(updateQuery, updateParams);
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Updated!', 'Category updated successfully.', 'success');", true);
                }
                else
                {
                    string insertQuery = "INSERT INTO Categories (CategoryName, Description, Status) VALUES (@CategoryName, @Description, @Status)";
                    SqlParameter[] insertParams = new SqlParameter[]
                    {
                        new SqlParameter("@CategoryName", SqlDbType.VarChar) { Value = categoryName },
                        new SqlParameter("@Description", SqlDbType.VarChar) { Value = description },
                        new SqlParameter("@Status", SqlDbType.VarChar) { Value = status }
                    };
                    dc.ExecuteNonQuery(insertQuery, insertParams);
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Saved!', 'Category created successfully.', 'success');", true);
                }

                ResetForm();
                BindGrid();
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving category: " + ex.Message);
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            BindGrid(TxtSearch.Text.Trim());
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            TxtSearch.Text = "";
            BindGrid();
        }

        protected void GridCategories_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridCategories.PageIndex = e.NewPageIndex;
            BindGrid(TxtSearch.Text.Trim());
        }

        protected void GridCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCategory")
            {
                int categoryId = Convert.ToInt32(e.CommandArgument);
                LoadCategoryForEdit(categoryId);
            }
            else if (e.CommandName == "DeleteCategory")
            {
                int categoryId = Convert.ToInt32(e.CommandArgument);
                DeleteCategory(categoryId);
            }
        }

        protected void GridCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Handled by RowCommand
        }

        private void LoadCategoryForEdit(int id)
        {
            try
            {
                string query = "SELECT * FROM Categories WHERE CategoryId = @CategoryId";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CategoryId", SqlDbType.Int) { Value = id }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    CategoryIdHidden.Value = row["CategoryId"].ToString();
                    TxtCategoryName.Text = row["CategoryName"].ToString();
                    TxtDescription.Text = row["Description"].ToString();
                    DdlStatus.SelectedValue = row["Status"].ToString();

                    FormTitleLabel.Text = "Edit Category";
                    BtnSave.Text = "Update Category";
                    BtnCancel.Visible = true;
                    AlertPanel.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading category details: " + ex.Message);
            }
        }

        private void DeleteCategory(int id)
        {
            try
            {
                // Verify if category has linked products
                string checkLinkQuery = "SELECT COUNT(*) FROM Products WHERE CategoryId = @CategoryId";
                SqlParameter[] checkParams = new SqlParameter[]
                {
                    new SqlParameter("@CategoryId", SqlDbType.Int) { Value = id }
                };
                int linkedCount = Convert.ToInt32(dc.ExecuteScalar(checkLinkQuery, checkParams));
                if (linkedCount > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Cannot Delete!', 'This category has active products. Reassign or delete them first.', 'error');", true);
                    return;
                }

                string deleteQuery = "DELETE FROM Categories WHERE CategoryId = @CategoryId";
                SqlParameter[] deleteParams = new SqlParameter[]
                {
                    new SqlParameter("@CategoryId", SqlDbType.Int) { Value = id }
                };
                dc.ExecuteNonQuery(deleteQuery, deleteParams);

                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Deleted!', 'Category deleted successfully.', 'success');", true);
                BindGrid(TxtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting category: " + ex.Message);
            }
        }

        private void ResetForm()
        {
            CategoryIdHidden.Value = "";
            TxtCategoryName.Text = "";
            TxtDescription.Text = "";
            DdlStatus.SelectedValue = "Active";
            FormTitleLabel.Text = "Add New Category";
            BtnSave.Text = "Save Category";
            BtnCancel.Visible = false;
            AlertPanel.Visible = false;
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }
    }
}
