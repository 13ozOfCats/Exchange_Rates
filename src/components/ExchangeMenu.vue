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
      buyMode: true,
      inputValue: null,
      rate: null
    };
  },
  computed: {
    nominal() {
      return this.currencies !== null && this.rate !== null
        ? this.currencies[this.rate].Nominal
        : 1;
    },
    debit() {
      let response = 0;
      if (this.currencies !== null && this.rate) {
        const currentVal = this.currencies[this.rate];
        response = (currentVal.Value * this.inputValue) / currentVal.Nominal;
      }
      return response;
    },
    btnText() {
      return this.buyMode ? "Купить" : "Продать";
    },
    sumText() {
      return this.buyMode ? "Заплачу:" : "Получу:";
    },
    available() {
      let inWallet = 0;
      if (this.currencies !== null && this.rate !== null) {
        const currentVal = this.currencies[this.rate];
        const canGet =
          Math.floor(this.wallet["RUR"] / currentVal.Value) *
          currentVal.Nominal;
        if (this.buyMode) {
          inWallet = canGet;
        } else {
          if (this.wallet[this.rate]) {
            inWallet = this.wallet[this.rate];
          }
        }
      }
      return inWallet;
    }
  },
  methods: {
    newRate(val) {
      this.rate = val;
    },
    transaction() {
      if (this.inputValue) {
        let newVal, newRur;
        const balance = this.wallet[this.rate] ? this.wallet[this.rate] : 0;
        const walletRur = this.wallet["RUR"];
        if (this.buyMode) {
          if (walletRur >= this.debit) {
            if (this.inputValue % this.nominal === 0) {
              newVal = balance + this.inputValue;
              newRur = walletRur - this.debit;
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
            alert("Не досточно денег на счету");
            return false;
          }
        } else {
          if (balance >= this.inputValue) {
            if (this.inputValue % this.nominal === 0) {
              newVal = balance - this.inputValue;
              newRur = walletRur + this.debit;
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
        this.$emit("update", {
          name: this.rate,
          value: newVal
        });
        this.$emit("update", {
          name: "RUR",
          value: newRur
        });
      } else {
        alert("Введите количество");
      }
    }
  }
};
</script>

<template>
  <div v-if="currencies">
    <RatesSelect :rates="currencies" @newRate="newRate" />
    <div class="controls__block">
      <div class="subtitle">
        Доступно:
      </div>
      <div class="controls__shrink">
        <span class="title"> {{ available.toFixed(2) }} {{ rate }}</span>
      </div>
    </div>
    <div class="controls__block">
      <div class="subtitle">
        Хочу:
      </div>
      <div class="controls__checkboxes">
        <label class="controls__label">
          <input
            class="controls__checkbox"
            type="radio"
            name="control"
            :value="true"
            v-model="buyMode"
          />
          <span>Купить</span>
        </label>
        <label class="controls__label">
          <input
            class="controls__checkbox"
            type="radio"
            name="control"
            :value="false"
            v-model="buyMode"
          />
          <span>Продать</span>
        </label>
      </div>
      <div class="controls__shrink">
        <label>
          <input
            type="number"
            class="controls__input"
            placeholder="0.00"
            v-model.number="inputValue"
            :min="nominal"
            :max="available"
            :step="nominal"
          />
        </label>
      </div>
    </div>
    <div class="controls__block">
      <div class="subtitle">
        {{ sumText }}
      </div>
      <div class="controls__shrink">
        <span class="title">{{ debit.toFixed(2) }} ₽</span>
      </div>
    </div>
    <div v-if="rate" class="controls__block">
      <button class="controls__btn" @click="transaction">
        {{ btnText }}
      </button>
    </div>
  </div>
</template>

<style scoped lang="scss">
.controls {
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
