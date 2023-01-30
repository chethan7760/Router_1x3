module router_top_tb();
reg clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
reg [7:0] data_in;
wire vld_out_0,vld_out_1,vld_out_2,err,busy;
wire [7:0] data_out_0,data_out_1,data_out_2;

integer i;

router_top DUT(clk,resetn,read_enb_0,read_enb_1,read_enb_2,data_in,pkt_valid,data_out_0,data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);

//clock generation
always
begin
#5 clk = 1'b0;
#5 clk = ~clk;
end

task initialize;
        {clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in} = 0;
endtask

task rst;
        begin
                @(negedge clk)
                resetn = 1'b0;
                @(negedge clk)
                resetn = 1'b1;
                end
        endtask


task read_0;
begin
#250 read_enb_0 = 1;
end
endtask

task read_1;
begin
#250 read_enb_1 = 1;
end
endtask

task read_2;
begin
#250 read_enb_2 = 1;
end
endtask

task write;
reg [7:0] header,pay_load,parity;
                reg [5:0] payload_length;
                reg [1:0] addr;
begin
@(negedge clk)
wait(!busy)

@(negedge clk)
parity = 0;
payload_length = 6'd18;
addr = 2'b00;
pkt_valid = 1;
header = {payload_length,addr};
data_in = header;
parity = parity ^ header;

@(negedge clk)
 wait(!busy)

for(i=0;i<payload_length;i=i+1)
begin
@(negedge clk)
pay_load = {$random}%256;
data_in = pay_load;
parity = parity^data_in;
end

@(negedge clk)
wait(!busy)
pkt_valid = 0;
data_in = parity;

end 
endtask

task packet_14;
reg [7:0] header,pay_load,parity;
                reg [5:0] payload_length;
                reg [1:0] addr;
begin
@(negedge clk)
wait(!busy)

@(negedge clk)
parity = 0;
payload_length = 6'd14;
addr = 2'b01;
pkt_valid = 1;
header = {payload_length,addr};
data_in = header;
parity = parity ^ header;

@(negedge clk)
 wait(!busy)

for(i=0;i<payload_length;i=i+1)
begin
@(negedge clk)
pay_load = {$random}%256;
data_in = pay_load;
parity = parity^data_in;
end

@(negedge clk)
wait(!busy)
pkt_valid = 0;
data_in = parity;

end 
endtask

task packet_25;
reg [7:0] header,pay_load,parity;
                reg [5:0] payload_length;
                reg [1:0] addr;
begin
@(negedge clk)
wait(!busy)

@(negedge clk)
parity = 0;
payload_length = 6'd25;
addr = 2'b10;
pkt_valid = 1;
header = {payload_length,addr};
data_in = header;
parity = parity ^ header;

@(negedge clk)
 wait(!busy)

for(i=0;i<payload_length;i=i+1)
begin
@(negedge clk)
pay_load = {$random}%256;
data_in = pay_load;
parity = parity^data_in;
end

@(negedge clk)
wait(!busy)
pkt_valid = 0;
data_in = parity;

end 
endtask


initial
begin
initialize;
rst;
fork
write;
read_0;
join
#200;
rst;
fork
packet_14;
//read_1;
join
#200;
rst;
fork
packet_25;
read_2;
join
#200;
$finish;
end

endmodule

