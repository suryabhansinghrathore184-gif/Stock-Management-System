using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class s_documents : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["sid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDocs();
            }
        }

        private void LoadDocs()
        {
            string sid = Session["sid"].ToString();
            try
            {
                string query = "SELECT DocId, DocumentType, FilePath, UploadedDate FROM SupplierDocuments WHERE SupplierId = @SupplierId ORDER BY UploadedDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                GvDocs.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvDocs.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading documents: " + ex.Message);
            }
        }

        protected void BtnUpload_Click(object sender, EventArgs e)
        {
            string sid = Session["sid"].ToString();
            string docType = DdlDocType.SelectedValue;

            if (!FuDoc.HasFile)
            {
                ShowAlert("Please select a file to upload.");
                return;
            }

            try
            {
                string ext = Path.GetExtension(FuDoc.FileName).ToLower();
                if (ext != ".pdf" && ext != ".png" && ext != ".jpg" && ext != ".jpeg")
                {
                    ShowAlert("Only PDF, PNG, and JPG files are allowed.");
                    return;
                }

                if (FuDoc.PostedFile.ContentLength > 5242880) // 5MB limit
                {
                    ShowAlert("File size must be under 5MB.");
                    return;
                }

                string dir = Server.MapPath("~/Links/");
                if (!Directory.Exists(dir))
                {
                    Directory.CreateDirectory(dir);
                }

                string cleanType = docType.Replace(" ", "_");
                string filename = sid + "_" + cleanType + "_" + Path.GetFileName(FuDoc.FileName);
                FuDoc.SaveAs(Path.Combine(dir, filename));

                // Insert into DB
                string query = "INSERT INTO SupplierDocuments (SupplierId, DocumentType, FilePath, UploadedDate) VALUES (@SupplierId, @DocType, @Path, GETDATE())";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@SupplierId", sid),
                    new SqlParameter("@DocType", docType),
                    new SqlParameter("@Path", filename)
                };
                dc.ExecuteNonQuery(query, param);

                ShowAlert("Document uploaded successfully!");
                LoadDocs();
            }
            catch (Exception ex)
            {
                ShowAlert("Upload failed: " + ex.Message);
            }
        }

        protected void GvDocs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteDoc")
            {
                int docId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    // 1. Get file name to delete from filesystem
                    string fileQuery = "SELECT FilePath FROM SupplierDocuments WHERE DocId = @DocId";
                    SqlParameter[] fParam = new SqlParameter[] { new SqlParameter("@DocId", docId) };
                    object fileObj = dc.ExecuteScalar(fileQuery, fParam);

                    if (fileObj != null)
                    {
                        string path = Path.Combine(Server.MapPath("~/Links/"), fileObj.ToString());
                        if (File.Exists(path))
                        {
                            File.Delete(path);
                        }
                    }

                    // 2. Delete record
                    string query = "DELETE FROM SupplierDocuments WHERE DocId = @DocId";
                    dc.ExecuteNonQuery(query, fParam);

                    ShowAlert("Document deleted successfully.");
                    LoadDocs();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error deleting document: " + ex.Message);
                }
            }
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}
