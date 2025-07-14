{...}: {
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.ts69 = {
      image = "teamspeaksystems/teamspeak6-server:latest";
      ports = [
        "9987:9987/udp" # Voice Port
        "30033:30033/tcp" # File Transfer
        # "10080:10080/tcp" # Web Query
      ];
      volumes = [
        "/var/lib/teamspeak-data:/var/tsserver/"
      ];
      environment = {
        TSSERVER_LICENSE_ACCEPTED = "accept";
        TSSERVER_DATABASE_PLUGIN = "sqlite3";
      };
      workdir = "/var/tsserver/";
    };
  };
}
