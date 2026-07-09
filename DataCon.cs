using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StockMangementSystem
{
    public class DataCon
    {
        private string connString;

        public DataCon()
        {
            // Fetch connection string from Web.config
            if (ConfigurationManager.ConnectionStrings["StockDB"] != null)
            {
                connString = ConfigurationManager.ConnectionStrings["StockDB"].ConnectionString;
            }
            else
            {
                connString = @"Data Source=.\SQLEXPRESS;Initial Catalog=stock mangement system;Integrated Security=True;TrustServerCertificate=True";
            }
        }

        public string GetConnectionString()
        {
            return connString;
        }

        // Keep for legacy code compatibility, but refactored to prevent connection leaks
        public void setdata(string s)
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(s, con))
                {
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Keep for legacy code compatibility
        public DataSet getdata(string s)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(s, con))
                {
                    da.Fill(ds);
                }
            }
            return ds;
        }

        // --- NEW PARAMETERIZED METHODS TO PREVENT SQL INJECTION ---

        public int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        public DataSet GetDataSet(string query, SqlParameter[] parameters = null)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public object ExecuteScalar(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    return cmd.ExecuteScalar();
                }
            }
        }

        // Transaction runner for complex business operations like Sales/Purchases
        public bool ExecuteTransaction(List<SqlCommand> commands)
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        foreach (SqlCommand cmd in commands)
                        {
                            cmd.Connection = con;
                            cmd.Transaction = trans;
                            cmd.ExecuteNonQuery();
                        }
                        trans.Commit();
                        return true;
                    }
                    catch (Exception)
                    {
                        trans.Rollback();
                        throw;
                    }
                }
            }
        }
    }
}