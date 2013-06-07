require 'dbi'
require 'mysql'
class InsertOperation

		#--------- Getting Database Connection object --------------
	def getting_Connection
		begin
			@dbconnection = DBI.connect("DBI:Mysql:rubyexample:localhost","root","root");
			@dbcon = Mysql.real_connect("localhost", "root", "root", "rubyexample")
		rescue DBI::DataBaseError => e
			puts e.err
		end
		select_Option
	end

		#------------- Displaying Options -------------------
	def select_Option
		print "1. Select Record \n"
		print "2. Insert Record \n"
		print "3. Update Record \n"
		print "4. Delete Record \n"
		print "Which Operation Do you Want to Process: \n"
		op1 = gets.chomp.to_i
			case op1
				when 1
					select_Record
				when 2
					inserting_Record
				when 3
					update_Record
				when 4
					delete_Record
				else
					puts "Sorry Wrong Option you choosed "
			end
	end

		#------------- Displaying Records -------------------
	def select_Record
			print "Do you want View all records or Particular Records \n"
			print "1. All Records \n"
			print "2. Particular Records \n"
			op2 = gets.chomp.to_i
				case op2
					when 1
						selrecords = @dbconnection.prepare("select *from products")
						selrecords.execute();
						printf "\n"
						print "+ ---------------+-----------------+-----------------+----------------------- +\n"
						print "|\t Pro_Id  |\t Pro_Name  |\t Pro_Cost    |\t Pro-Quantity\t      |\n"						
						print "+ ---------------+-----------------+-----------------+----------------------- +\n"
						selrecords.fetch do |row|
							printf "|\t   %d     | %15s |\t   %7d   |\t%7d  \t      |\n", row[0], row[1], row[2], row[3]
						end
						selrecords.finish
						print "+ ---------------+-----------------+-----------------+----------------------- +\n"
						printf "\n"

						
					when 2
						print "Enter Which ProductId: \n"
						num = gets.chomp.to_i
						selrecords = @dbconnection.prepare("select *from products where pro_id=#{num}")
						selrecords.execute();
						printf "\n"
						print "+ ---------------+-----------------+-----------------+----------------------- +\n"
						print "|\t Pro_Id  |\t Pro_Name  |\t Pro_Cost    |\t Pro-Quantity\t      |\n"					
						print "+ ---------------+-----------------+-----------------+----------------------- +\n"
						selrecords.fetch do |row|
							printf "|\t   %d     | %15s |\t   %7d   |\t%7d  \t      |\n", row[0], row[1], row[2], row[3]
						end
						selrecords.finish
						print "+ --------------------------------------------------------------------------- +\n"
						printf "\n"
					else
						puts "Sorry Wrong Option you choosed"
				end			
			closing_Connection
	end
	
			#------------- Inserting Records -------------------
	def inserting_Record
		print "Enter Product Id: "
		@pid = gets.chomp.to_i;
		print "Enter Product Name: "
		@pname = gets.chomp;
		@pname = "'"+@pname+"'";
		print "Enter Product Cost: "
		@pcost = gets.chomp.to_i;
		print "Enter Product Quantity: "
		@pqty = gets.chomp.to_i;
		#puts @pname
		#insquery = @dbconnection.do("insert into products values(#{@pid},#{@pname},#{@pcost},#{@pqty})")
		insquery = @dbconnection.prepare("insert into products(pro_id,pro_name,pro_cost,pro_quantity)values(?,?,?,?)")
		begin		
			insquery.execute(@pid,@pname,@pcost,@pqty)
			insquery.finish
			puts "Record Inserted Successfully........"
			@dbconnection.commit
			print "Do you Want to Insert One more Record: for Yes Press Y for No Press N:  "		
			op = gets.chomp
				case op
					when "Y", "y"
						inserting_Record
					when "N", "n"
						puts "Thank you "
					else
						puts "Wrong Option Sorry...."
						closing_Connection
				end
		rescue
			puts "Duplicate Entry Occurred Try again"
			inserting_Record
			
		end
	end

			#------------- Updating Records -------------------
	def update_Record
		print "Updating Product Quantities \n"
		print "Enter Product name and quantities to update the records \n"
		name = gets.chomp
		name = "'%"+name+"%'"
		qty = gets.chomp.to_i
		@dbcon.query("update products set pro_quantity=#{qty} where pro_name like #{name}")
		puts "#{@dbcon.affected_rows} Rows were Updated...."
		
		closing_Connection
	end

			#------------	Deleting Records ------------------
	def delete_Record
		print "Do you want Delete all records or Particular Records \n"
		print "1. All Records \n"
		print "2. Particular Records \n"
		op2 = gets.chomp.to_i
			case op2
				when 1
					@dbcon.query("delete from products")
					puts "#{@dbcon.affected_rows} Records were Deleted"
				when 2
					print "Enter Which ProductId: \n"
					num = gets.chomp.to_i
					@dbcon.query("delete from products where pro_id=#{num}")
					puts "#{@dbcon.affected_rows} Records were Deleted"
				else
					puts "Sorry Wrong Option you choosed"
			end			
		closing_Connection
	end
	

			#------------- Logic to Close the Connection -------------------
	def closing_Connection
		@dbconnection.disconnect if @dbconnection
		@dbcon.close if @dbcon
	end
end

	insop = InsertOperation.new
	insop.getting_Connection

