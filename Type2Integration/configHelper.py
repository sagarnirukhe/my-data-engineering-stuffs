import configparser
config = configparser.ConfigParser()
config.read("/home/saif/PycharmProjects/Type2Integration/parameters.conf")

def getProperty(section, propertyname):
    return config.get(section, propertyname)
