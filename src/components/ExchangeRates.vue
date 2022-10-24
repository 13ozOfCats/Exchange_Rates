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
      wallet: {},
      date: null,
      loading: true
    };
  },
  async mounted() {
    await axios
      .get("https://www.cbr-xml-daily.ru/daily_json.js")
      .then(response => {
        if (response.data) {
          const res = response.data;
          const date = res.Date.split("T")[0].split("-");
          this.date = date[2] + "." + date[1] + "." + date[0];
          this.currencies = res.Valute;
        }
      })
      .finally(() => (this.loading = false));
    this.getWallet();
  },
  methods: {
    getWallet() {
      const wallet = localStorage.getItem("wallet");
      if (wallet) {
        wallet.split("|").forEach(pair => {
          if (pair) {
            const vals = pair.split(":");
            this.$set(this.wallet, vals[0], Number(vals[1]));
          }
        });
      } else {
        this.setWallet({ name: "RUR", value: 10000 });
      }
    },
    setWallet(newVal) {
      const newPrice = newVal.value;
      if (newVal.value) {
        if (this.wallet[newVal.name]) {
          this.wallet[newVal.name] = newPrice;
        } else {
          this.$set(this.wallet, newVal.name, newPrice);
        }
      } else {
        this.$delete(this.wallet, newVal.name);
      }
      let walletString = "";
      for (const key in this.wallet) {
        walletString += key + ":" + this.wallet[key] + "|";
      }
      localStorage.setItem("wallet", walletString);
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
        @update="setWallet"
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
