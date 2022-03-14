// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Tue Jul 20 22:04:07 IST 2021
// For connector: org.apache.sqoop.manager.MySQLManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class QueryResult extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private Integer customer_id;
  public Integer get_customer_id() {
    return customer_id;
  }
  public void set_customer_id(Integer customer_id) {
    this.customer_id = customer_id;
  }
  public QueryResult with_customer_id(Integer customer_id) {
    this.customer_id = customer_id;
    return this;
  }
  private String customer_fname;
  public String get_customer_fname() {
    return customer_fname;
  }
  public void set_customer_fname(String customer_fname) {
    this.customer_fname = customer_fname;
  }
  public QueryResult with_customer_fname(String customer_fname) {
    this.customer_fname = customer_fname;
    return this;
  }
  private String customer_lname;
  public String get_customer_lname() {
    return customer_lname;
  }
  public void set_customer_lname(String customer_lname) {
    this.customer_lname = customer_lname;
  }
  public QueryResult with_customer_lname(String customer_lname) {
    this.customer_lname = customer_lname;
    return this;
  }
  private java.sql.Timestamp order_date;
  public java.sql.Timestamp get_order_date() {
    return order_date;
  }
  public void set_order_date(java.sql.Timestamp order_date) {
    this.order_date = order_date;
  }
  public QueryResult with_order_date(java.sql.Timestamp order_date) {
    this.order_date = order_date;
    return this;
  }
  private String order_status;
  public String get_order_status() {
    return order_status;
  }
  public void set_order_status(String order_status) {
    this.order_status = order_status;
  }
  public QueryResult with_order_status(String order_status) {
    this.order_status = order_status;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.customer_id == null ? that.customer_id == null : this.customer_id.equals(that.customer_id));
    equal = equal && (this.customer_fname == null ? that.customer_fname == null : this.customer_fname.equals(that.customer_fname));
    equal = equal && (this.customer_lname == null ? that.customer_lname == null : this.customer_lname.equals(that.customer_lname));
    equal = equal && (this.order_date == null ? that.order_date == null : this.order_date.equals(that.order_date));
    equal = equal && (this.order_status == null ? that.order_status == null : this.order_status.equals(that.order_status));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.customer_id == null ? that.customer_id == null : this.customer_id.equals(that.customer_id));
    equal = equal && (this.customer_fname == null ? that.customer_fname == null : this.customer_fname.equals(that.customer_fname));
    equal = equal && (this.customer_lname == null ? that.customer_lname == null : this.customer_lname.equals(that.customer_lname));
    equal = equal && (this.order_date == null ? that.order_date == null : this.order_date.equals(that.order_date));
    equal = equal && (this.order_status == null ? that.order_status == null : this.order_status.equals(that.order_status));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.customer_id = JdbcWritableBridge.readInteger(1, __dbResults);
    this.customer_fname = JdbcWritableBridge.readString(2, __dbResults);
    this.customer_lname = JdbcWritableBridge.readString(3, __dbResults);
    this.order_date = JdbcWritableBridge.readTimestamp(4, __dbResults);
    this.order_status = JdbcWritableBridge.readString(5, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.customer_id = JdbcWritableBridge.readInteger(1, __dbResults);
    this.customer_fname = JdbcWritableBridge.readString(2, __dbResults);
    this.customer_lname = JdbcWritableBridge.readString(3, __dbResults);
    this.order_date = JdbcWritableBridge.readTimestamp(4, __dbResults);
    this.order_status = JdbcWritableBridge.readString(5, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void loadLargeObjects0(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeInteger(customer_id, 1 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(customer_fname, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(customer_lname, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(order_date, 4 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(order_status, 5 + __off, 12, __dbStmt);
    return 5;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeInteger(customer_id, 1 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(customer_fname, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(customer_lname, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(order_date, 4 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(order_status, 5 + __off, 12, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.customer_id = null;
    } else {
    this.customer_id = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.customer_fname = null;
    } else {
    this.customer_fname = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.customer_lname = null;
    } else {
    this.customer_lname = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.order_date = null;
    } else {
    this.order_date = new Timestamp(__dataIn.readLong());
    this.order_date.setNanos(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.order_status = null;
    } else {
    this.order_status = Text.readString(__dataIn);
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.customer_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.customer_id);
    }
    if (null == this.customer_fname) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, customer_fname);
    }
    if (null == this.customer_lname) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, customer_lname);
    }
    if (null == this.order_date) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.order_date.getTime());
    __dataOut.writeInt(this.order_date.getNanos());
    }
    if (null == this.order_status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, order_status);
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.customer_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.customer_id);
    }
    if (null == this.customer_fname) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, customer_fname);
    }
    if (null == this.customer_lname) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, customer_lname);
    }
    if (null == this.order_date) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.order_date.getTime());
    __dataOut.writeInt(this.order_date.getNanos());
    }
    if (null == this.order_status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, order_status);
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    __sb.append(FieldFormatter.escapeAndEnclose(customer_id==null?"null":"" + customer_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(customer_fname==null?"null":customer_fname, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(customer_lname==null?"null":customer_lname, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(order_date==null?"null":"" + order_date, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(order_status==null?"null":order_status, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    __sb.append(FieldFormatter.escapeAndEnclose(customer_id==null?"null":"" + customer_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(customer_fname==null?"null":customer_fname, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(customer_lname==null?"null":customer_lname, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(order_date==null?"null":"" + order_date, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(order_status==null?"null":order_status, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.customer_id = null; } else {
      this.customer_id = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.customer_fname = null; } else {
      this.customer_fname = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.customer_lname = null; } else {
      this.customer_lname = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.order_date = null; } else {
      this.order_date = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.order_status = null; } else {
      this.order_status = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.customer_id = null; } else {
      this.customer_id = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.customer_fname = null; } else {
      this.customer_fname = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.customer_lname = null; } else {
      this.customer_lname = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.order_date = null; } else {
      this.order_date = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.order_status = null; } else {
      this.order_status = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    o.order_date = (o.order_date != null) ? (java.sql.Timestamp) o.order_date.clone() : null;
    return o;
  }

  public void clone0(QueryResult o) throws CloneNotSupportedException {
    o.order_date = (o.order_date != null) ? (java.sql.Timestamp) o.order_date.clone() : null;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("customer_id", this.customer_id);
    __sqoop$field_map.put("customer_fname", this.customer_fname);
    __sqoop$field_map.put("customer_lname", this.customer_lname);
    __sqoop$field_map.put("order_date", this.order_date);
    __sqoop$field_map.put("order_status", this.order_status);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("customer_id", this.customer_id);
    __sqoop$field_map.put("customer_fname", this.customer_fname);
    __sqoop$field_map.put("customer_lname", this.customer_lname);
    __sqoop$field_map.put("order_date", this.order_date);
    __sqoop$field_map.put("order_status", this.order_status);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("customer_id".equals(__fieldName)) {
      this.customer_id = (Integer) __fieldVal;
    }
    else    if ("customer_fname".equals(__fieldName)) {
      this.customer_fname = (String) __fieldVal;
    }
    else    if ("customer_lname".equals(__fieldName)) {
      this.customer_lname = (String) __fieldVal;
    }
    else    if ("order_date".equals(__fieldName)) {
      this.order_date = (java.sql.Timestamp) __fieldVal;
    }
    else    if ("order_status".equals(__fieldName)) {
      this.order_status = (String) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
  public boolean setField0(String __fieldName, Object __fieldVal) {
    if ("customer_id".equals(__fieldName)) {
      this.customer_id = (Integer) __fieldVal;
      return true;
    }
    else    if ("customer_fname".equals(__fieldName)) {
      this.customer_fname = (String) __fieldVal;
      return true;
    }
    else    if ("customer_lname".equals(__fieldName)) {
      this.customer_lname = (String) __fieldVal;
      return true;
    }
    else    if ("order_date".equals(__fieldName)) {
      this.order_date = (java.sql.Timestamp) __fieldVal;
      return true;
    }
    else    if ("order_status".equals(__fieldName)) {
      this.order_status = (String) __fieldVal;
      return true;
    }
    else {
      return false;    }
  }
}
