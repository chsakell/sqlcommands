using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlCommands
{
    class Program
    {
        const string sqlConnectionString = "Data Source=localhost;Initial Catalog=SchoolDB;Integrated Security=SSPI;";

        static void Main(string[] args)
        {
            // SqlDataAdapter
            DataSet students = GetStudents();

            // ExecuteScalar
            int resultCode = AddStudent(1, "Chris", 28); // Should get -1 (already record with this ID)
            int resultCode2 = AddStudent(5, "Smith", 130); // Should get -2 (Invalid age number)
            int resultCode3 = AddStudent(5, "Jason", 21); // Should get 0 (Success)
            // ExecuteNonQuery
            int row1 = UpdateStudent(1, "Chris S."); // Should return 1 // Row found and updated
            int row2 = UpdateStudent(30, "Helen K."); // Should return 0 // Row not found

            // Compininations in SqlTransaction : Very helpfull!!
            if(ExecuteBatchQueries(sqlConnectionString))
            {
                Console.WriteLine("Transaction completed");
            }
            else
            {
                Console.WriteLine("Transaction failed to complete");
            }
        }

        // Retrieve multiple records using an SqlDataAdapter
        public static DataSet GetStudents()
        {
            DataSet dsStudents = new DataSet();

            using (SqlConnection con = new SqlConnection(sqlConnectionString))
            {
                SqlCommand cmd = new SqlCommand("GetStudents", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);

                try
                {
                    da.Fill(dsStudents);
                    dsStudents.Tables[0].TableName = "Students";
                }
                catch (Exception)
                {
                    return dsStudents;
                }
            }
            return dsStudents;
        }

        // Add student using the execute scalar in order to get the result code
        public static int AddStudent(int id, string name, int age)
        {
            int resultCode;

            using (SqlConnection con = new SqlConnection(sqlConnectionString))
            {
                SqlCommand cmd = new SqlCommand("AddStudent", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@studentID", DbType.Int32).Value = id;
                cmd.Parameters.Add("@studentName", DbType.String).Value = name;
                cmd.Parameters.Add("@studentAge", DbType.Int32).Value = age;
                try
                {
                    con.Open();
                    resultCode = (int)cmd.ExecuteScalar();
                    con.Close();
                }
                catch (Exception)
                {
                    return -10; // unknown error
                }
            }
            return resultCode;
        }

        public static int UpdateStudent(int id, string newName)
        {
            int rowsAffected;

            using (SqlConnection con = new SqlConnection(sqlConnectionString))
            {
                SqlCommand cmd = new SqlCommand("UpdateStudentsName", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@studentID", DbType.Int32).Value = id;
                cmd.Parameters.Add("@studentNewName", DbType.String).Value = newName;
                try
                {
                    con.Open();
                    rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();
                }
                catch (Exception)
                {
                    return 0; // unknown error
                }
            }
            return rowsAffected;
        }

        // Use SqlCommands in a Transaction
        public static bool ExecuteBatchQueries(string conStr)
        {
            bool transactionExecuted = false;

            List<Student> studentList = new List<Student>();
            Student s1 = new Student { ID = 10, Name = "John", Age = 34 };
            Student s2 = new Student { ID = 11, Name = "John", Age = 23 };
            Student s3 = new Student { ID = 12, Name = "John", Age = 54 };
            Student s4 = new Student { ID = 10, Name = "John", Age = 44 };

            studentList.Add(s1); studentList.Add(s2); studentList.Add(s3); studentList.Add(s4);

            using (var con = new SqlConnection(conStr))
            {
                SqlTransaction trans = null;
                try
                {
                    con.Open();
                    trans = con.BeginTransaction();
                    foreach (Student student in studentList)
                    {
                        SqlCommand cmd = new SqlCommand("AddStudent", con,trans);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@studentID", DbType.Int32).Value = student.ID;
                        cmd.Parameters.Add("@studentName", DbType.String).Value = student.Name;
                        cmd.Parameters.Add("@studentAge", DbType.Int32).Value = student.Age;
                        int resultCode = (int)cmd.ExecuteScalar();
                        if (resultCode != 0)
                        {
                            trans.Rollback();
                            return transactionExecuted; // false
                        }
                    }
                    trans.Commit();
                    transactionExecuted = true;
                    con.Close();
                }
                catch (Exception Ex)
                {
                    if (trans != null) trans.Rollback();
                    return false;
                }
                return transactionExecuted;
            }

        }
    }
}
