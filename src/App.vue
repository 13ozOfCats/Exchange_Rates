<template lang="html">
  <div id="app">
    <div v-if="currencys" class="main__block">
      <ratesSelect :rates="currencys" @newRate="newRate"></ratesSelect>
      <div class="controlls__block">
        <div class="subtitle">
          Доступно:
        </div>
        <div class="controlls__shrink">
          <span class="title"> {{ availible }} {{ rate }}</span>
        </div>
      </div>
      <div class="controlls__block">
        <div class="subtitle">
          Хочу:
        </div>
        <div class="controlls__checkboxes">
          <label class="controlls__label">
            <input
              class="controlls__checkbox"
              type="radio"
              value="buy"
              name="controll"
              checked="checked"
              v-model="mode"
            />
            <span>Купить</span>
          </label>
          <label class="controlls__label">
            <input
              class="controlls__checkbox"
              type="radio"
              value="sell"
              name="controll"
              v-model="mode"
            />
            <span>Продать</span>
          </label>
        </div>
        <div class="controlls__shrink">
          <label>
            <input
              type="number"
              class="controlls__input"
              placeholder="0.00"
              v-model.number="inputValue"
              :min="nominal"
              :max="availible"
              :step="nominal"
            />
          </label>
        </div>
      </div>
      <div class="controlls__block">
        <div class="subtitle">
          {{ sumText }}
        </div>
        <div class="controlls__shrink">
          <span class="title">{{ debit }} ₽</span>
        </div>
      </div>
      <div v-if="mode && rate" class="controlls__block">
        <button class="controlls__btn" @click="Transaction">
          {{ btn }}
        </button>
      </div>
    </div>
    <div class="main__block">
      <div class="title">Курс валют на {{ date }}</div>
      <table class="table main__coursetable">
        <thead class="table__thead">
          <tr class="table__row">
            <td>
              Код
            </td>
            <td>
              Единиц
            </td>
            <td>
              Курс
            </td>
          </tr>
        </thead>
        <tbody class="table__tbody">
          <tr v-for="(val, name) in currencys" :key="name" class="table__row">
            <td class="table__name">
              {{ name }}
            </td>
            <td class="table__num">
              {{ val.Nominal }}
            </td>
            <td
              class="table__cost"
              :style="{
                color: getColor(val.Value, val.Previous)
              }"
            >
              {{ val.Value }} ({{ getDifference(val.Value, val.Previous) }})
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="main__block">
      <div class="title">
        Баланс
      </div>
      <table class="table">
        <tbody class="table__tbody">
          <tr v-for="(value, key) in wallet" :key="key" class="table__row">
            <td class="table__rate">
              {{ key }}
            </td>
            <td class="table__val">
              {{ value }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script lang="js">
import ratesSelect from "./components/ratesSelect";
import axios from "axios";

export default {
  name: "App",
  components: {
    ratesSelect
  },
  data() {
    return {
      currencys: null,
      date: null,
      rate: null,
      inputValue: null,
      wallet: {},
      loading: true,
      mode: 'buy',
    }
  },
  computed: {
    btn: function () {
      if (this.mode === 'buy'){
        return 'Купить';
      } else if (this.mode === 'sell'){
        return 'Продать';
      } else {
        return '';
      }
    },
    sumText: function () {
      if (this.mode === 'buy'){
        return 'Заплачу:';
      } else if (this.mode === 'sell'){
        return 'Получу:';
      } else {
        return '';
      }
    },
    nominal: function() {
      if((this.currencys !== null) && (this.rate !== null)) {
        return this.currencys[this.rate].Nominal;
      } else {
        return 1;
      }
    },
    debit: function () {
      let response = 0;
      if((this.currencys !== null) && (this.rate)) {
        const currentVal = this.currencys[this.rate];
        response = ((currentVal.Value * this.inputValue) / currentVal.Nominal);
      }
      return parseFloat(response).toFixed(2);
    },
    availible: function () {
      let inWallet = 0;
      if((this.currencys !== null) && (this.rate !== null)) {
        const currentVal = this.currencys[this.rate];
        let canGet = Math.floor(this.wallet['RUR'] / currentVal.Value) * currentVal.Nominal
        if (this.mode === 'buy'){
          inWallet = canGet;
        } else if (this.mode === 'sell'){
          if ( this.wallet[this.rate] ) {
            inWallet = this.wallet[this.rate];
          }
        }
      }
      return parseFloat(inWallet).toFixed(2);
    }
  },
  methods: {
    getData: function(res) {
      const date = res.Date.split('T')[0].split('-');
      this.date = date[2] + '.' + date[1] + '.' + date[0];
      this.currencys = res.Valute;
    },
    getDifference: function(now, prev) {
      const difference = (now - prev).toFixed(2);
      if (difference > 0) {
        return '+' + difference;
      } else {
        return difference;
      }
    },
    getColor: function(now, prev) {
      const difference = (now - prev).toFixed(2);
      let color;
      if(difference > 0) {
       color = '#00b956';
      } else if (difference < 0) {
        color = '#f62434';
      } else if (difference === 0) {
        color = '#000000';
      }
      return color;
    },
    getWallet: function() {
      const wallet = localStorage.getItem('wallet');
      if (wallet) {
        wallet.split('|').forEach((pair) => {
          if(pair){
            const vals = pair.split(':');
            this.$set(this.wallet, vals[0], vals[1]);
          }
        });
      } else {
        this.setWallet('RUR', 10000);
      }
    },
    setWallet: function(name, price) {
      let walletString = '';
      const newPrice = parseFloat(price).toFixed(2);
      if(this.wallet[name]){
        this.wallet[name] = newPrice;
      } else {
        this.$set(this.wallet, name , newPrice);
      }
      for (const key in this.wallet) {
        walletString += key + ':' + this.wallet[key] + '|';
      }
      localStorage.setItem('wallet', walletString);
    },
    Transaction: function () {
      if (this.inputValue) {
        let newVal;
        let newRur;
        const balance = parseFloat(this.wallet[this.rate] ? this.wallet[this.rate] : 0);
        const wallet = parseFloat(this.wallet['RUR']);
        const debit = parseFloat(this.debit);
        if (this.mode === 'buy') {
          if (wallet >= debit) {
            if(this.inputValue % this.nominal === 0) {
              newVal = balance + this.inputValue;
              newRur = wallet - debit;
            } else {
              alert('Эта валюьа продается по '+ this.nominal + ' единиц. Введите число, кратное ' + this.nominal)
              return false;
            }
          } else {
            alert('Не дочточно денег на счету')
            return false;
          }
        } else if (this.mode === 'sell') {
          if (balance >= this.inputValue) {
            if(this.inputValue % this.nominal === 0) {
              newVal = balance - this.inputValue;
              newRur = wallet + debit;
            } else {
              alert('Эта валюта продается по '+ this.nominal + ' единиц. Введите число, кратное ' + this.nominal)
              return false;
            }
          } else {
            alert('Валюты на счету меньше чем вы хотите продать')
            return false;
          }
        }
        this.setWallet(this.rate, newVal);
        this.setWallet('RUR', newRur);
      } else {
        alert('Введите количество')
      }
    },
    newRate: function (val) {
      this.rate = val;
    },
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
};
</script>
<style lang="scss">
@import url("https://fonts.googleapis.com/css2?family=PT+Sans:wght@400;700&display=swap");
* {
  box-sizing: border-box;
}
body {
  font-family: PT Sans, sans-serif;
}
.main {
  &__coursetable {
    margin-top: 16px;
    width: 100%;
    text-align: center;
  }
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
.controlls {
  &__label {
    flex-basis: 50%;
    width: 50%;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    background: #ffffff;
    border: 1px solid #d8d8d8;
    cursor: pointer;
  }
  &__checkboxes {
    margin-top: 8px;
    display: flex;
    width: 100%;
  }
  &__checkbox {
    display: none;
    &:checked + span {
      color: #34aaf2;
    }
  }
  &__input {
    padding: 0 16px;
    width: 256px;
    height: 40px;
    font-style: normal;
    font-weight: normal;
    font-size: 16px;
    line-height: 24px;
    background: #ffffff;
    border: 1px solid #d8d8d8;
    box-sizing: border-box;
    outline: none;
  }
  &__block {
    margin-top: 16px;
    width: 100%;
  }
  &__btn {
    height: 32px;
    font-style: normal;
    font-weight: bold;
    font-size: 13px;
    line-height: 16px;
    width: 100%;
    color: #ffffff;
    border: 1px solid #00b956;
    background: #00b956;
    cursor: pointer;
    outline: none;
  }
  &__shrink {
    margin-top: 8px;
    width: 100%;
  }
}
.table {
  font-family: PT Sans, sans-serif;
  font-style: normal;
  font-weight: normal;
  font-size: 13px;
  line-height: 16px;
  margin-top: 16px;
  width: 100%;
  &__row {
    height: 32px;
    width: 100%;
  }
  &__val {
    text-align: right;
  }
  &__name {
    width: 20%;
  }
  &__num {
    width: 40%;
  }
  &__cost {
    width: 40%;
  }
  &__thead {
    color: rgba(51, 51, 51, 0.5);
    box-shadow: 0 1px 0 #d8d8d8;
  }
  &__tbody {
    text-transform: uppercase;
    color: #000000;
  }
}
.title {
  font-style: normal;
  font-weight: bold;
  font-size: 16px;
  line-height: 24px;
  color: #000000;
}
.subtitle {
  font-family: PT Sans, sans-serif;
  font-style: normal;
  font-weight: normal;
  font-size: 13px;
  line-height: 16px;
  color: rgba(51, 51, 51, 0.5);
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  display: flex;
}
</style>
