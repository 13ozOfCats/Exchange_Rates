<script>
import axios from "axios";
import AccountBalance from "@/components/AccountBalance";
import RatesTable from "@/components/RatesTable";
import ExchangeMenu from "@/components/ExchangeMenu";

export default {
  name: "ExchangeRates",
  components: {
    ExchangeMenu,
    RatesTable,
    AccountBalance
  },
  data() {
    return {
      currencies: null,
      date: null,
      wallet: {},
      loading: true
    };
  },
  mounted() {
    axios
      .get("https://www.cbr-xml-daily.ru/daily_json.js")
      .then(response => {
        this.getData(response.data);
      })
      .catch(err => {
        console.log(err);
      })
      .finally(() => (this.loading = false));
    this.getWallet();
  },
  methods: {
    getData: function(res) {
      const date = res.Date.split("T")[0].split("-");
      this.date = date[2] + "." + date[1] + "." + date[0];
      this.currencies = res.Valute;
    },
    getWallet: function() {
      const wallet = localStorage.getItem("wallet");
      if (wallet) {
        wallet.split("|").forEach(pair => {
          if (pair) {
            const vals = pair.split(":");
            this.$set(this.wallet, vals[0], vals[1]);
          }
        });
      } else {
        this.setWallet("RUR", 10000);
      }
    },
    setWallet: function(name, price) {
      let walletString = "";
      const newPrice = parseFloat(price).toFixed(2);
      if (price > 0) {
        if (this.wallet[name]) {
          this.wallet[name] = newPrice;
        } else {
          this.$set(this.wallet, name, newPrice);
        }
        for (const key in this.wallet) {
          walletString += key + ":" + this.wallet[key] + "|";
        }
        localStorage.setItem("wallet", walletString);
      } else {
        this.$delete(this.wallet, name);
      }
    }
  }
};
</script>

<template>
  <div class="exchange-rates">
    <template v-if="currencies">
      <ExchangeMenu
        :currencies="currencies"
        :wallet="wallet"
        class="exchange-rates__block"
      />
      <RatesTable
        class="exchange-rates__block"
        :date="date"
        :currencies="currencies"
      />
      <AccountBalance :wallet="wallet" class="exchange-rates__block" />
    </template>
  </div>
</template>

<style scoped lang="scss">
.exchange-rates {
  display: flex;
}

.exchange-rates {
  &__block {
    width: 288px;
    padding: 32px 16px;
    background: #f6f6f6;
    margin-left: 16px;
    box-sizing: border-box;

    &:nth-child(2) {
      width: 320px;
      background: #ffffff;
    }
  }
}
</style>
