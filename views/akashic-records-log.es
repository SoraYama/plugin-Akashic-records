import React from 'react'
import { LogCP } from './containers/checkbox-panel'
import StatisticsPanel from './containers/statistics-panel'
import VisibleTable from './containers/visible-table'


const AkashicLog = React.createClass({
  shouldComponentUpdate: () => false,
  render() {
    return (
      <div>
        <LogCP contentType={this.props.contentType} />
        <StatisticsPanel contentType={this.props.contentType} />
        <VisibleTable contentType={this.props.contentType} />
      </div>
    )
  },
})

export default AkashicLog
