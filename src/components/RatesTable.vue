<script>
export default {
  name: "RatesTable",
  props: {
    date: {
      type: String,
      required: true
    },
    currencies: {
      type: Array,
      required: true
    }
  },
  methods: {
    getDifference: function(now, prev) {
      const difference = (now - prev).toFixed(2);
      if (difference > 0) {
        return "+" + difference;
      } else {
        return difference;
      }
    },
    getColor: function(now, prev) {
      const difference = (now - prev).toFixed(2);
      let color;
      if (difference > 0) {
        color = "#00b956";
      } else if (difference < 0) {
        color = "#f62434";
      } else if (difference === 0) {
        color = "#000000";
      }
      return color;
    }
  }
};
</script>

<template>
  <div class="rates-table">
    <div class="title">Курс валют на {{ date }}</div>
    <table class="table rates-table__course-table">
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
        <tr v-for="(val, name) in currencies" :key="name" class="table__row">
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
</template>

<style scoped lang="scss">
.rates-table {
  &__course-table {
    margin-top: 16px;
    width: 100%;
    text-align: center;
  }
}
</style>
