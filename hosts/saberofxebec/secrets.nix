{...}: {
  age.secrets.speedtest-tracker = {
    file = ../../secrets/speedtest-tracker.age;
    owner = "root";
    group = "root";
  };
  age.secrets.homarr = {
    file = ../../secrets/homarr.age;
    owner = "root";
    group = "root";
  };
}
