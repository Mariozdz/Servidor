package Logic;


public class Auser {

  private String id;
  private String password;
  private String name;
  private String surnames;
  private double latitud;
  private double longitud;
  private String cellphone;
  private int usertype;


  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }


  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }


  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }


  public String getSurnames() {
    return surnames;
  }

  public void setSurnames(String surnames) {
    this.surnames = surnames;
  }


  public double getLatitud() {
    return latitud;
  }

  public void setLatitud(double latitud) {
    this.latitud = latitud;
  }


  public double getLongitud() {
    return longitud;
  }

  public void setLongitud(double longitud) {
    this.longitud = longitud;
  }


  public String getCellphone() {
    return cellphone;
  }

  public void setCellphone(String cellphone) {
    this.cellphone = cellphone;
  }


  public int getUsertype() {
    return usertype;
  }

  public void setUsertype(int usertype) {
    this.usertype = usertype;
  }

}
