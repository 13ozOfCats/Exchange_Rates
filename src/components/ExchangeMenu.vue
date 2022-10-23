<script>
import RatesSelect from "@/components/RatesSelect";

export default {
  name: "ExchangeMenu",
  components: {
    RatesSelect
  },
  props: {
    currencies: {
      type: Object,
      required: true
    },
    wallet: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      mode: "buy",
      inputValue: null,
      rate: null
    };
  },
  computed: {
    nominal() {
      if (this.currencies !== null && this.rate !== null) {
        return this.currencies[this.rate].Nominal;
      } else {
        return 1;
      }
    },
    debit() {
      let response = 0;
      if (this.currencies !== null && this.rate) {
        const currentVal = this.currencies[this.rate];
        response = (currentVal.Value * this.inputValue) / currentVal.Nominal;
      }
      return parseFloat(response).toFixed(2);
    },
    btn() {
      if (this.mode === "buy") {
        return "Купить";
      } else if (this.mode === "sell") {
        return "Продать";
      } else {
        return "";
      }
    },
    sumText() {
      if (this.mode === "buy") {
        return "Заплачу:";
      } else if (this.mode === "sell") {
        return "Получу:";
      } else {
        return "";
      }
    },
    availible() {
      let inWallet = 0;
      if (this.currencies !== null && this.rate !== null) {
        const currentVal = this.currencies[this.rate];
        let canGet =
          Math.floor(this.wallet["RUR"] / currentVal.Value) *
          currentVal.Nominal;
        if (this.mode === "buy") {
          inWallet = canGet;
        } else if (this.mode === "sell") {
          if (this.wallet[this.rate]) {
            inWallet = this.wallet[this.rate];
          }
        }
      }
      return parseFloat(inWallet).toFixed(2);
    }
  },
  methods: {
    newRate(val) {
      this.rate = val;
    },
    transaction() {
      if (this.inputValue) {
        let newVal;
        let newRur;
        const balance = parseFloat(
          this.wallet[this.rate] ? this.wallet[this.rate] : 0
        );
        const wallet = parseFloat(this.wallet["RUR"]);
        const debit = parseFloat(this.debit);
        if (this.mode === "buy") {
          if (wallet >= debit) {
            if (this.inputValue % this.nominal === 0) {
              newVal = balance + this.inputValue;
              newRur = wallet - debit;
            } else {
              alert(
                "Эта валюьа продается по " +
                  this.nominal +
                  " единиц. Введите число, кратное " +
                  this.nominal
              );
              return false;
            }
          } else {
            alert("Не дочточно денег на счету");
            return false;
          }
        } else if (this.mode === "sell") {
          if (balance >= this.inputValue) {
            if (this.inputValue % this.nominal === 0) {
              newVal = balance - this.inputValue;
              newRur = wallet + debit;
            } else {
              alert(
                "Эта валюта продается по " +
                  this.nominal +
                  " единиц. Введите число, кратное " +
                  this.nominal
              );
              return false;
            }
          } else {
            alert("Валюты на счету меньше чем вы хотите продать");
            return false;
          }
        }
        this.setWallet(this.rate, newVal);
        this.setWallet("RUR", newRur);
      } else {
        alert("Введите количество");
      }
    }
  }
};
</script>

<template>
  <div v-if="currencies">
    <RatesSelect :rates="currencies" @newRate="newRate"></RatesSelect>
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
      <button class="controlls__btn" @click="transaction">
        {{ btn }}
      </button>
    </div>
  </div>
</template>

<style scoped lang="scss">
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
</style>
