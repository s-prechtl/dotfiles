{...}: {
  programs.wofi = {
    enable = true;
    settings = {
      allow-images = true;
      image-size = "64px";
      gtk_dark = true;
      insensitive = true;
      halign = true;
      location = "center";
      prompt = "Search...";
      orientation = "vertical";
    };
    style = ''
      @define-color base00 #282828;
      @define-color base01 #3C3836;
      @define-color base02 #504945;
      @define-color base03 #665C54;
      @define-color base04 #BDAE93;
      @define-color base06 #D5C4A1;
      @define-color base06 #EBDBB2;
      @define-color base07 #FBF1C7;
      @define-color base08 #FB4934;
      @define-color base09 #FE8019;
      @define-color base0A #FABD2F;
      @define-color base0B #B8BB26;
      @define-color base0C #8EC07C;
      @define-color base0D #83A598;
      @define-color base0E #D3869B;
      @define-color base0F #D65D0E;

      window {
      	margin: 5px;
      	border-radius: 10px;
      	background-color: @base03;
      }

      #input {
      	border-radius: 5px;
      	background-color: @base03;
          color: @base06;
      }

      #inner-box {
      	margin: 5px;
      	color: @base06;
      	background-color: @base00;
      }

      #outer-box {
      	margin: 5px;
      	background-color: @base00;
      }

      #scroll {
      	margin: 5px;
      	background-color: @base00;
      }

      #text {
      	margin: 2px;
      }

    '';
  };
}
