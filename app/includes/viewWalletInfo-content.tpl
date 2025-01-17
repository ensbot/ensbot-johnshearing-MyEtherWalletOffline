<section class="col-sm-8 view-wallet-content">

  <section class="row">
    <h1 class="col-xs-12" translate="VIEWWALLET_SuccessMsg">Success! Here are your wallet details.</h1>

    <div class="col-sm-10">
      <div class="account-help-icon">
        <img src="images/icon-help.svg" class="help-icon" />
        <p class="account-help-text" translate="x_AddessDesc">You may know this as your "Account #" or your "Public Key". It's what you send people so they can send you ETH. That icon is an easy way to recognize your address.</p>
        <h5 translate="x_Address">Your Address:</h5>
      </div>
      <input class="form-control" type="text" ng-value="wallet.getChecksumAddressString()" readonly="readonly">
    </div>
    <div class="col-sm-2 address-identicon-container">
      <div class="addressIdenticon" title="Address Indenticon" blockie-address="{{wallet.getAddressString()}}" watch-var="wallet"></div>
    </div>
  </section>

  <!-- No need for this section to ever show -->
  <section ng-show=false>
    <div class="account-help-icon">
      <img src="images/icon-help.svg" class="help-icon" />
      <p class="account-help-text" translate="x_KeystoreDesc">This Keystore / JSON file matches the format used by Mist & Geth so you can easily import it in the future. It is the recommended file to download and back up.</p>
      <h5 translate="x_Keystore">Keystore/JSON File (Recommended • Encrypted • Mist/Geth Format)</h5>
    </div>
    <a class="btn btn-info btn-block" href="{{blobEnc}}" download="{{encFileName}}" translate="x_Download"> DOWNLOAD </a>
  </section>

  <section ng-show="wallet.type=='default'">
    <div class="account-help-icon">
      <img src="images/icon-help.svg" class="help-icon" />
      <p class="account-help-text" translate="x_PrivKeyDesc">This is the unencrypted text version of your private key, meaning no password is necessary. If someone were to find your unencrypted private key, they could access your wallet without a password. For this reason, encrypted versions are typically recommended.</p>
      <h5>
        <span translate="x_PrivKey">Private Key (unencrypted)</span>
      </h5>
    </div>
    <div class="input-group">
      <input class="form-control no-animate" type="{{pkeyVisible ? 'text' : 'password'}}" ng-value="wallet.getPrivateKeyString()" readonly="readonly">
      <span tabindex="0" aria-label="make private key visible" role="button" class="input-group-addon eye" ng-click="showHidePkey()"></span>
    </div>
  </section>

  <!-- Start of: Defines the section used for generating a KeyStore file -->
  <section class="row" ng-show='!showEnc' style="border-style: solid; border-width: 3px; margin: 15px 0px 15px 0px;">
    <h1 translate="x_GenKeyStoreFileHeading" aria-live="polite" style="text-align: center;"> Generate an encrypted private key and save it as a KeyStore file</h1>
    <div class="col-sm-8 col-sm-offset-2">
      <!-- Start of: Defines a text edit field used to enter a password for generating a KeyStore file -->    
      <h4 translate="GEN_Label_1"> Enter a strong password at least 9 characters using upper and lower case and using numbers and punctuation as well. Make it something easy to remember but hard to guess. </h4>
      <div class="input-group">
        <input name="newKeyStoreFilepassword"
               class="form-control"
               type="{{showPass && 'password' || 'text'}}"
               placeholder="{{ 'GEN_Placeholder_1' | translate }}"
               ng-model="newKeyStoreFilepassword"
               ng-class="isStrongPass() ? 'is-valid' : 'is-invalid'"
               aria-label="{{ 'GEN_Label_1' |translate}}"/>
        <span tabindex="0" aria-label="make password visible" role="button" class="input-group-addon eye" ng-click="showPass=!showPass"></span>
      </div>
      <!-- End of: Defines a text edit field used to enter a password for generating a KeyStore file -->      


      <!-- Start of: Defines button to generate a KeyStore file -->
      <section ng-show='!showEnc'>
        <div class="account-help-icon">
          <img src="images/icon-help.svg" class="help-icon" />
          <p class="account-help-text" translate="x_GenerateKeyStoreHelp">To make a KeyStore file: Provide a password (Make it a good one at least 9 characters long using upper and lower case letters as well as numbers and punctuation). Then press this button to encrypt the private key. You are not done yet! You must then save the encrypted data to a KeyStore file by pressing the <strong>Download</strong> button. The KeyStore file will then be saved in the <strong>Download</strong> directory. You can then make copies of the KeyStore file and keep them in a different directory if you prefer. You should then be able to access your Ethereum account using the KeyStore file by supplying the password when prompted. After making and then downloading the KeyStore file, be sure that it works and that you can actually use it to access the account for which you made it. You must test this by actually using the keystore file to move ether <strong>OUT</strong> of the account for which the key was made. Many people have lost huge amounts of ether because they did not actually check that they could move ether out of the accounts for which the KeyStore file was made. Also, be sure to print out several hard copies of your private key (That is called making a Paper Wallet). Store your paper wallets in several different <strong>SECURE</strong> locations in case of device failure, fire, theft, natural disasters, civil war, or if you forget the password to your KeyStore file. Remember, your KeyStore files are password protected, but paper wallets are NOT password protected. If anyone finds one of your paper wallets then they can use it to get your ether. So keep your paper wallets (print outs of your private key) in a very secure location.</p> 
          <h5>
            <span translate="x_GenerateKeyStoreFileLabel">Generate an encrypted private key</span>
          </h5>
        </div>
        <a tabindex="0" role="button" class="btn btn-primary btn-block" func="generateSingleWallet" ng-click="generateKeyStoreFile()" translate="x_GenerateKeyStoreButtonTxt">Generate KeyStore</a>
      </section>
      <!-- End of: Defines button to generate a KeyStore file -->



        <!-- Start of: Defines button to download a KeyStore file -->
        <section ng-show='!showEnc'>
          <div class="account-help-icon">
            <img src="images/icon-help.svg" class="help-icon" />
            <p class="account-help-text" translate="x_GenerateKeyStoreHelp">Provide a password. Then press this button to encrypt the private key and store the encrpted data in a KeyStore file which will be saved to the <strong>Download</strong> directory. The you should be able to access your Ethereum account using the KeyStore account by supplying the password. After making the KeyStore file, be sure that it works and that you can actually use it to access the account for which you made it. You and test this by actually using the keystore file to move ether out of the account for which the key was made. Also, be sure to print out several hard copies of your private key and store these in several different locations in case of device failure, fire, theft, natural disasters, civil war, or if you forget the password to your KeyStore file.</p> 
            <h5>
              <span translate="x_DownloadKeyStoreFileLabel">Then download your encrypted private key</span>
            </h5>
          </div>

          <a tabindex="0" role="button" class="btn btn-primary btn-block" href="{{blobEnc}}" download="{{encFileName}}" translate="x_DownloadKeyStoreButtonTxt" aria-label="{{'x_DownloadKeyStoreButtonTxt'|translate}} {{'x_Keystore'|translate}}" aria-describedby="x_KeystoreDesc" ng-click="downloaded()"> DOWNLOAD </a>

        </section>
        <!-- End of: Defines button to download a KeyStore file -->

      <br />
      <hr />
    </div>
  </section>
  <!-- End of: Defines the section used for generating a KeyStore file -->

  <section ng-show="wallet.type=='default'">
    <div class="account-help-icon">
      <img src="images/icon-help.svg" class="help-icon" />
      <p class="account-help-text" translate="x_PrintDesc">ProTip: Click print and save this as a PDF, even if you do not own a printer!</p>
      <h5 translate="x_Print">Print Paper Wallet:</h5>
    </div>
    <a class="btn btn-info btn-block" ng-click="printQRCode()" translate="x_Print">Print Paper Wallet</a>
  </section>

  <section class="row">
    <div class="col-xs-6">
      <h5 translate="x_Address">Your Address:</h5>
      <div class="qr-code" qr-code="{{wallet.getAddressString()}}" watch-var="wallet" width="100%"></div>
    </div>
    <div class="col-xs-6">
      <h5 ng-show="wallet.type=='default'">
        <span translate="x_PrivKey">Private Key (unencrypted)</span>
      </h5>
      <div class="qr-pkey-container" ng-show="wallet.type=='default'">
        <div class="qr-overlay" ng-show="!pkeyVisible"></div>
        <div class="qr-code" qr-code="{{wallet.getPrivateKeyString()}}" watch-var="wallet" width="100%"></div>
        <div class="input-group">
          <input class="form-control no-animate" type="{{pkeyVisible ? 'text' : 'password'}}" ng-value="wallet.getPrivateKeyString()" readonly="readonly" style="display:none;width:0;height:0;padding:0">
          <span tabindex="0" aria-label="make private key visible" role="button" class="input-group-addon eye" ng-click="showHidePkey()"></span>
        </div>
      </div>
    </div>
  </section>

